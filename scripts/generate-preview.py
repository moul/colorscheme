#!/usr/bin/env python3
"""Generate preview images of the color schemes"""

import os
import sys
from PIL import Image, ImageDraw, ImageFont

def parse_xrdb(filename):
    """Parse colors from xrdb file"""
    colors = {}
    with open(filename, 'r') as f:
        for line in f:
            if line.startswith('#define'):
                parts = line.split()
                if len(parts) >= 3:
                    color_name = parts[1]
                    color_value = parts[2]
                    colors[color_name] = color_value
    return colors

def generate_preview(colors, output_file, title="ManfredTouron Color Scheme"):
    """Generate a preview image of the color scheme"""
    # Image settings
    width = 800
    height = 600
    cell_size = 60
    padding = 20
    
    # Create image with background color
    bg_color = colors.get('Background_Color', '#000000')
    fg_color = colors.get('Foreground_Color', '#ffffff')
    
    img = Image.new('RGB', (width, height), bg_color)
    draw = ImageDraw.Draw(img)
    
    # Try to use a monospace font
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 16)
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 24)
    except:
        font = ImageFont.load_default()
        title_font = font
    
    # Draw title
    draw.text((padding, padding), title, fill=fg_color, font=title_font)
    
    # Draw color grid
    y_offset = padding + 50
    
    # Draw ANSI colors 0-7
    draw.text((padding, y_offset), "Normal Colors:", fill=fg_color, font=font)
    y_offset += 25
    
    for i in range(8):
        x = padding + (i * (cell_size + 5))
        y = y_offset
        color = colors.get(f'Ansi_{i}_Color', '#000000')
        
        # Draw color box
        draw.rectangle([x, y, x + cell_size, y + cell_size], fill=color, outline=fg_color)
        
        # Draw color number
        text = str(i)
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        text_x = x + (cell_size - text_width) // 2
        text_y = y + (cell_size - text_height) // 2
        
        # Use contrasting color for text
        text_color = '#000000' if i > 0 else '#ffffff'
        draw.text((text_x, text_y), text, fill=text_color, font=font)
    
    # Draw ANSI colors 8-15
    y_offset += cell_size + 20
    draw.text((padding, y_offset), "Bright Colors:", fill=fg_color, font=font)
    y_offset += 25
    
    for i in range(8, 16):
        x = padding + ((i - 8) * (cell_size + 5))
        y = y_offset
        color = colors.get(f'Ansi_{i}_Color', '#000000')
        
        # Draw color box
        draw.rectangle([x, y, x + cell_size, y + cell_size], fill=color, outline=fg_color)
        
        # Draw color number
        text = str(i)
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        text_x = x + (cell_size - text_width) // 2
        text_y = y + (cell_size - text_height) // 2
        
        # Use contrasting color for text
        text_color = '#000000'
        draw.text((text_x, text_y), text, fill=text_color, font=font)
    
    # Draw sample text
    y_offset += cell_size + 40
    draw.text((padding, y_offset), "Sample Text:", fill=fg_color, font=font)
    y_offset += 25
    
    sample_texts = [
        ("Normal text in foreground color", fg_color),
        ("Red text sample", colors.get('Ansi_1_Color', '#ff0000')),
        ("Green text sample", colors.get('Ansi_2_Color', '#00ff00')),
        ("Yellow text sample", colors.get('Ansi_3_Color', '#ffff00')),
        ("Blue text sample", colors.get('Ansi_4_Color', '#0000ff')),
        ("Magenta text sample", colors.get('Ansi_5_Color', '#ff00ff')),
        ("Cyan text sample", colors.get('Ansi_6_Color', '#00ffff')),
    ]
    
    for text, color in sample_texts:
        draw.text((padding + 20, y_offset), text, fill=color, font=font)
        y_offset += 25
    
    # Save image
    img.save(output_file)
    print(f"Generated {output_file}")

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root_dir = os.path.dirname(script_dir)
    
    # Check if PIL is available
    try:
        from PIL import Image, ImageDraw, ImageFont
    except ImportError:
        print("Error: Pillow library not found. Install with: pip install Pillow")
        sys.exit(1)
    
    # Generate dark theme preview
    dark_xrdb = os.path.join(root_dir, 'ManfredTouron.xrdb')
    if os.path.exists(dark_xrdb):
        colors = parse_xrdb(dark_xrdb)
        output_file = os.path.join(root_dir, 'assets', 'preview-dark.png')
        os.makedirs(os.path.dirname(output_file), exist_ok=True)
        generate_preview(colors, output_file, "ManfredTouron Dark Theme")
    
    # Generate light theme preview
    light_xrdb = os.path.join(root_dir, 'ManfredTouron-Light.xrdb')
    if os.path.exists(light_xrdb):
        colors = parse_xrdb(light_xrdb)
        output_file = os.path.join(root_dir, 'assets', 'preview-light.png')
        generate_preview(colors, output_file, "ManfredTouron Light Theme")

if __name__ == '__main__':
    main()