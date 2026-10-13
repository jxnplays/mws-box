#!/usr/bin/env python3
"""
KAPF Fastfile Reader for CoD3

Reads KAPF fastfiles and extracts:
1. Asset names
2. Collision/brush chunks (if section table exposes them)
3. Spawn-point records (if they are in the zone)

Does not invent a layout - only reads what the header and section table expose.
If a section is not readable, writes the offset and first 64 bytes, then stops on that section.
"""

import struct
import json
from pathlib import Path

ROOT = Path(r"[local path] of Duty 3\Call of Duty 3")
OUTPUT = Path(r"[local path]

def read_header(data):
    """Read and parse the KAPF header."""
    if len(data) < 0x40:
        return None
    
    magic = data[0:4]
    if magic != b'KAPF':
        return None
    
    header = {
        'magic': 'KAPF',
        'version_flags': struct.unpack('<I', data[4:8])[0],
        'section_table_offset': struct.unpack('<I', data[8:12])[0],
        'version': struct.unpack('<I', data[12:16])[0],
        'asset_count': struct.unpack('<I', data[16:20])[0],
        'asset_table_size': struct.unpack('<I', data[20:24])[0],
        'data_offset': struct.unpack('<I', data[24:28])[0],
    }
    
    # Section name at 0x1C
    section_name = data[0x1C:0x24].rstrip(b'\x00').decode('ascii', errors='replace')
    header['section_name'] = section_name
    
    return header

def find_sections(data):
    """Find known sections in the fastfile."""
    sections = {}
    known_sections = [b'CODLOCS', b'AUDIO', b'FLI', b'CODAUTO', b'XEMESH', b'XETEX']
    
    for sec_name in known_sections:
        pos = data.find(sec_name)
        if pos >= 0:
            sections[sec_name.decode()] = pos
    
    return sections

def extract_asset_names(data, header):
    """Extract asset names from the fastfile."""
    asset_names = []
    
    # Look for patterns that look like asset names
    # CoD3 asset names typically have extensions like .xemesh, .xetex, .xeanim, etc.
    import re
    for m in re.finditer(rb'[\x20-\x7e]{3,}\.(?:xemesh|xetex|xeanim|xeb|xec|bpeb|btrb|zbbb|xmpbb|xmbb|aitbb|cfgstrb|dcgb|ncgb|dtrb|phyb|scnb|gdbb|dbb|bindicb|atrbb|fli|ib|ng)\x00', data):
        name = m.group().rstrip(b'\x00').decode('ascii')
        asset_names.append({
            'name': name,
            'offset': m.start(),
        })
    
    return asset_names

def try_read_collision(data, sections):
    """Try to read collision/brush chunks from the fastfile."""
    collision_data = []
    
    # Look for collision-related section names
    collision_sections = [b'COL', b'BRUSH', b'COLLISION', b'TERRAIN', b'HEIGHTMAP']
    
    for sec_name in collision_sections:
        pos = data.find(sec_name)
        if pos >= 0:
            # Read the section header
            section_header = data[pos:pos+64]
            collision_data.append({
                'section_name': sec_name.decode(),
                'offset': pos,
                'header_hex': section_header.hex(),
                'header_ascii': ''.join(chr(b) if 32 <= b < 127 else '.' for b in section_header),
            })
    
    return collision_data

def try_read_spawns(data, sections):
    """Try to read spawn-point records from the fastfile."""
    spawn_data = []
    
    # Look for spawn-related strings
    import re
    spawn_patterns = [rb'spawn', rb'Spawn', rb'SPAWN', rb'player_spawn', rb'info_player']
    
    for pattern in spawn_patterns:
        for m in re.finditer(pattern, data):
            # Get context around the match
            start = max(0, m.start() - 32)
            end = min(len(data), m.end() + 32)
            context = data[start:end]
            
            spawn_data.append({
                'pattern': pattern.decode(),
                'offset': m.start(),
                'context_hex': context.hex(),
                'context_ascii': ''.join(chr(b) if 32 <= b < 127 else '.' for b in context),
            })
            
            # Limit to first 10 matches per pattern
            if len(spawn_data) >= 10:
                break
    
    return spawn_data

def write_unreadable_section(data, offset, section_name):
    """Write the offset and first 64 bytes of an unreadable section."""
    section_data = data[offset:offset+64]
    return {
        'section_name': section_name,
        'offset': offset,
        'first_64_bytes_hex': section_data.hex(),
        'first_64_bytes_ascii': ''.join(chr(b) if 32 <= b < 127 else '.' for b in section_data),
        'status': 'unreadable - stopped on this section',
    }

def main():
    print("KAPF Fastfile Reader for CoD3")
    print("=" * 60)
    
    # Open the fastfile
    fpath = ROOT / "mp" / "mpmaynne" / "mpmaynne.cod"
    print(f"Opening: {fpath}")
    
    with open(fpath, "rb") as f:
        data = f.read()
    
    print(f"File size: {len(data):,} bytes")
    print()
    
    # Read header
    print("Reading header...")
    header = read_header(data)
    if not header:
        print("ERROR: Not a valid KAPF file")
        return
    
    print(f"  Magic: {header['magic']}")
    print(f"  Version: {header['version']}")
    print(f"  Asset count: {header['asset_count']}")
    print(f"  Asset table size: {header['asset_table_size']}")
    print(f"  Data offset: {header['data_offset']}")
    print(f"  Section name: {header['section_name']}")
    print()
    
    # Find sections
    print("Finding sections...")
    sections = find_sections(data)
    for name, offset in sections.items():
        print(f"  {name}: offset 0x{offset:06x}")
    print()
    
    # Create output directory
    OUTPUT.mkdir(parents=True, exist_ok=True)
    
    # 1. Extract asset names
    print("Extracting asset names...")
    asset_names = extract_asset_names(data, header)
    print(f"  Found {len(asset_names)} asset names")
    
    # Write asset names to file
    with open(OUTPUT / "asset_names.txt", "w", encoding="utf-8") as f:
        f.write("=== KAPF Asset Names ===\n")
        f.write(f"Source: mp/mpmaynne/mpmaynne.cod\n")
        f.write(f"Total: {len(asset_names)}\n\n")
        for asset in asset_names:
            f.write(f"0x{asset['offset']:06x}: {asset['name']}\n")
    
    print(f"  Written to: {OUTPUT / 'asset_names.txt'}")
    print()
    
    # 2. Try to read collision/brush chunks
    print("Looking for collision/brush chunks...")
    collision_data = try_read_collision(data, sections)
    
    if collision_data:
        print(f"  Found {len(collision_data)} collision-related sections")
        with open(OUTPUT / "collision_chunks.txt", "w", encoding="utf-8") as f:
            f.write("=== KAPF Collision/Brush Chunks ===\n")
            f.write(f"Source: mp/mpmaynne/mpmaynne.cod\n")
            f.write(f"Total: {len(collision_data)}\n\n")
            for chunk in collision_data:
                f.write(f"Section: {chunk['section_name']}\n")
                f.write(f"Offset: 0x{chunk['offset']:06x}\n")
                f.write(f"Header (hex): {chunk['header_hex']}\n")
                f.write(f"Header (ascii): {chunk['header_ascii']}\n")
                f.write("\n")
        print(f"  Written to: {OUTPUT / 'collision_chunks.txt'}")
    else:
        print("  No collision/brush sections found")
        # Write unreadable section info
        unreadable = write_unreadable_section(data, 0, "COLLISION")
        with open(OUTPUT / "collision_chunks.txt", "w", encoding="utf-8") as f:
            f.write("=== KAPF Collision/Brush Chunks ===\n")
            f.write(f"Source: mp/mpmaynne/mpmaynne.cod\n")
            f.write("No collision/brush sections found in section table\n")
            f.write(f"First 64 bytes of file:\n")
            f.write(f"  Hex: {unreadable['first_64_bytes_hex']}\n")
            f.write(f"  ASCII: {unreadable['first_64_bytes_ascii']}\n")
        print(f"  Written to: {OUTPUT / 'collision_chunks.txt'}")
    print()
    
    # 3. Try to read spawn-point records
    print("Looking for spawn-point records...")
    spawn_data = try_read_spawns(data, sections)
    
    if spawn_data:
        print(f"  Found {len(spawn_data)} spawn-related entries")
        with open(OUTPUT / "spawn_points.txt", "w", encoding="utf-8") as f:
            f.write("=== KAPF Spawn-Point Records ===\n")
            f.write(f"Source: mp/mpmaynne/mpmaynne.cod\n")
            f.write(f"Total: {len(spawn_data)}\n\n")
            for spawn in spawn_data:
                f.write(f"Pattern: {spawn['pattern']}\n")
                f.write(f"Offset: 0x{spawn['offset']:06x}\n")
                f.write(f"Context (hex): {spawn['context_hex']}\n")
                f.write(f"Context (ascii): {spawn['context_ascii']}\n")
                f.write("\n")
        print(f"  Written to: {OUTPUT / 'spawn_points.txt'}")
    else:
        print("  No spawn-point records found")
        with open(OUTPUT / "spawn_points.txt", "w", encoding="utf-8") as f:
            f.write("=== KAPF Spawn-Point Records ===\n")
            f.write(f"Source: mp/mpmaynne/mpmaynne.cod\n")
            f.write("No spawn-point records found in zone\n")
        print(f"  Written to: {OUTPUT / 'spawn_points.txt'}")
    print()
    
    # Write summary
    with open(OUTPUT / "summary.json", "w", encoding="utf-8") as f:
        json.dump({
            'header': header,
            'sections': sections,
            'asset_count': len(asset_names),
            'collision_sections': len(collision_data),
            'spawn_entries': len(spawn_data),
        }, f, indent=2)
    
    print(f"Summary written to: {OUTPUT / 'summary.json'}")
    print()
    print("Done.")

if __name__ == '__main__':
    main()
