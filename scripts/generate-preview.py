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

def generate_color_table_previews(root_dir):
    """Generate previews from the contrib color table scripts"""
    import subprocess
    import tempfile
    
    # Check if PIL is available
    try:
        from PIL import Image, ImageFont, ImageDraw
    except ImportError:
        print("Skipping color table previews - Pillow not available")
        return
    
    assets_dir = os.path.join(root_dir, 'assets')
    os.makedirs(assets_dir, exist_ok=True)
    
    scripts = [
        ('16-color-table.sh', 'color-table-16', '16 Color Table'),
        ('256-color-table.sh', 'color-table-256', '256 Color Table'),
        ('24-bit-color.sh', 'color-table-24bit', '24-bit Color Test')
    ]
    
    # Generate for both dark and light themes
    themes = [
        ('ManfredTouron.xrdb', 'dark'),
        ('ManfredTouron-Light.xrdb', 'light')
    ]
    
    for script_name, output_base, title in scripts:
        script_path = os.path.join(root_dir, 'contrib', script_name)
        if not os.path.exists(script_path):
            print(f"Script {script_path} not found, skipping")
            continue
        
        for theme_file, theme_name in themes:
            theme_path = os.path.join(root_dir, theme_file)
            if not os.path.exists(theme_path):
                print(f"Theme {theme_path} not found, skipping")
                continue
                
            try:
                # Apply theme colors to terminal before running script
                env = os.environ.copy()
                
                # Load theme colors
                theme_colors = parse_xrdb(theme_path)
                
                # Set terminal colors using ANSI escape sequences
                color_setup = ""
                for i in range(16):
                    color_key = f'Ansi_{i}_Color'
                    if color_key in theme_colors:
                        color = theme_colors[color_key]
                        # Convert hex to RGB
                        hex_color = color.lstrip('#')
                        if len(hex_color) == 6:
                            r = int(hex_color[0:2], 16)
                            g = int(hex_color[2:4], 16)
                            b = int(hex_color[4:6], 16)
                            # OSC 4 sequence to set palette color
                            color_setup += f"\033]4;{i};rgb:{r:02x}/{g:02x}/{b:02x}\033\\"
                
                # Set background and foreground colors
                if 'Background_Color' in theme_colors:
                    bg = theme_colors['Background_Color'].lstrip('#')
                    if len(bg) == 6:
                        r = int(bg[0:2], 16)
                        g = int(bg[2:4], 16) 
                        b = int(bg[4:6], 16)
                        color_setup += f"\033]11;rgb:{r:02x}/{g:02x}/{b:02x}\033\\"
                
                if 'Foreground_Color' in theme_colors:
                    fg = theme_colors['Foreground_Color'].lstrip('#')
                    if len(fg) == 6:
                        r = int(fg[0:2], 16)
                        g = int(fg[2:4], 16)
                        b = int(fg[4:6], 16)
                        color_setup += f"\033]10;rgb:{r:02x}/{g:02x}/{b:02x}\033\\"
                
                # Run the script and capture output
                script_cmd = f"printf '{color_setup}'; bash {script_path}"
                result = subprocess.run(script_cmd, 
                                      capture_output=True, 
                                      text=True, 
                                      shell=True,
                                      timeout=30)
                
                if result.returncode == 0:
                    # Convert ANSI output to image
                    output_name = f"{output_base}-{theme_name}.png"
                    output_file = os.path.join(assets_dir, output_name)
                    theme_title = f"{title} ({theme_name.title()} Theme)"
                    ansi_to_image(result.stdout, output_file, theme_title, theme_colors)
                    print(f"Generated {output_file}")
                else:
                    print(f"Error running {script_name} with {theme_name}: {result.stderr}")
                    
            except subprocess.TimeoutExpired:
                print(f"Timeout running {script_name} with {theme_name}")
            except Exception as e:
                print(f"Error generating preview for {script_name} with {theme_name}: {e}")

def ansi_to_image(ansi_text, output_file, title, theme_colors=None):
    """Convert ANSI colored text to image"""
    from PIL import Image, ImageDraw, ImageFont
    import re
    
    # Parse ANSI codes and create image
    lines = ansi_text.split('\n')
    
    # Image settings
    font_size = 14
    line_height = font_size + 6
    char_width = 8  # Will be calculated from actual font
    padding = 20
    
    # Use theme colors if provided
    bg_color = '#000000'
    fg_color = '#ffffff'
    
    if theme_colors:
        bg_color = theme_colors.get('Background_Color', '#000000')
        fg_color = theme_colors.get('Foreground_Color', '#ffffff')
    
    # Default ANSI color palette - will be overridden by theme if available
    ansi_colors = {
        0: '#000000',   # black
        1: '#ff0000',   # red
        2: '#00ff00',   # green
        3: '#ffff00',   # yellow
        4: '#0000ff',   # blue
        5: '#ff00ff',   # magenta
        6: '#00ffff',   # cyan
        7: '#ffffff',   # white
        8: '#808080',   # bright black
        9: '#ff8080',   # bright red
        10: '#80ff80',  # bright green
        11: '#ffff80',  # bright yellow
        12: '#8080ff',  # bright blue
        13: '#ff80ff',  # bright magenta
        14: '#80ffff',  # bright cyan
        15: '#ffffff'   # bright white
    }
    
    # Override with theme colors if available
    if theme_colors:
        for i in range(16):
            color_key = f'Ansi_{i}_Color'
            if color_key in theme_colors:
                ansi_colors[i] = theme_colors[color_key]
    
    # Calculate dimensions more carefully
    # Count actual printable lines (non-empty after stripping ANSI)
    printable_lines = [line for line in lines if strip_ansi_codes(line).strip()]
    line_count = len(printable_lines) if printable_lines else len(lines)
    
    # Calculate max width by checking each line
    max_line_length = 0
    for line in lines:
        clean_line = strip_ansi_codes(line)
        if len(clean_line) > max_line_length:
            max_line_length = len(clean_line)
    
    if max_line_length == 0:
        max_line_length = 80
        
    width = min(max_line_length * char_width + padding * 2, 1400)
    height = max(line_count * line_height + padding * 2 + 50, 300)  # Ensure minimum height
    
    # Create image
    img = Image.new('RGB', (width, height), bg_color)
    draw = ImageDraw.Draw(img)
    
    # Try to use a monospace font
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", font_size)
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 18)
        # Calculate actual character width
        char_bbox = font.getbbox('X')
        char_width = char_bbox[2] - char_bbox[0]
    except:
        font = ImageFont.load_default()
        title_font = font
        char_width = 8
    
    # Draw title
    draw.text((padding, padding), title, fill=fg_color, font=title_font)
    
    # Parse and render ANSI colored text
    y_offset = padding + 40  # More space after title
    for line in lines:
        # Skip completely empty lines, but process lines with only ANSI codes
        clean_line = strip_ansi_codes(line)
        if not clean_line and not line.strip():
            y_offset += line_height
            continue
            
        x_offset = padding
        current_fg = fg_color
        current_bg = bg_color
        bold = False
        
        # Enhanced ANSI parser - split more carefully
        # Handle both 'm' sequences and other escape sequences
        parts = re.split(r'(\033\[[0-9;]*[a-zA-Z])', line)
        
        for part in parts:
            if part.startswith('\033['):
                # Parse ANSI escape sequence
                if part.endswith('m'):
                    codes_str = part[2:-1]  # Remove \033[ and m
                    if codes_str == '':
                        codes = ['0']
                    else:
                        codes = codes_str.split(';')
                    
                    i = 0
                    while i < len(codes):
                        code = codes[i]
                        if code == '' or code == '0':
                            # Reset all
                            current_fg = fg_color
                            current_bg = bg_color
                            bold = False
                        elif code == '1':
                            bold = True
                        elif code.isdigit():
                            code_int = int(code)
                            if code_int == 38 and i + 2 < len(codes) and codes[i + 1] == '5':
                                # 256-color foreground: 38;5;n
                                color_idx = int(codes[i + 2])
                                if color_idx < 16:
                                    current_fg = ansi_colors.get(color_idx, fg_color)
                                else:
                                    # Use a default color for 256-color palette beyond 16
                                    current_fg = fg_color
                                i += 2  # Skip the 5 and color index
                            elif code_int == 48 and i + 2 < len(codes) and codes[i + 1] == '5':
                                # 256-color background: 48;5;n
                                color_idx = int(codes[i + 2])
                                if color_idx < 16:
                                    current_bg = ansi_colors.get(color_idx, bg_color)
                                else:
                                    # Generate colors for 256-color palette beyond 16
                                    if color_idx < 232:
                                        # 6x6x6 color cube (216 colors)
                                        color_idx -= 16
                                        r = (color_idx // 36) * 51
                                        g = ((color_idx % 36) // 6) * 51  
                                        b = (color_idx % 6) * 51
                                        current_bg = f'#{r:02x}{g:02x}{b:02x}'
                                    else:
                                        # Grayscale (24 colors)
                                        gray = min(255, 8 + (color_idx - 232) * 10)
                                        current_bg = f'#{gray:02x}{gray:02x}{gray:02x}'
                                i += 2  # Skip the 5 and color index
                            elif 30 <= code_int <= 37:  # foreground colors
                                color_idx = code_int - 30
                                if bold:
                                    color_idx += 8  # Use bright version
                                current_fg = ansi_colors.get(color_idx, fg_color)
                            elif 40 <= code_int <= 47:  # background colors
                                color_idx = code_int - 40
                                current_bg = ansi_colors.get(color_idx, bg_color)
                            elif 90 <= code_int <= 97:  # bright foreground colors
                                current_fg = ansi_colors.get(code_int - 90 + 8, fg_color)
                            elif 100 <= code_int <= 107:  # bright background colors
                                current_bg = ansi_colors.get(code_int - 100 + 8, bg_color)
                        i += 1
                # Ignore other escape sequences (cursor movement, etc.)
            else:
                # Draw text with current colors
                if part:
                    # Calculate text width for background - use actual font metrics
                    text_bbox = font.getbbox(part)
                    text_width = text_bbox[2] - text_bbox[0]
                    text_height = font_size
                    
                    # For spaces and color blocks, make sure we draw the background
                    if current_bg != bg_color:
                        # Draw background rectangle for the entire text area
                        draw.rectangle([x_offset, y_offset, x_offset + text_width, y_offset + text_height], fill=current_bg)
                    
                    # Only draw text if it's not just spaces (or draw it for contrast)
                    if part.strip() or current_bg != bg_color:
                        draw.text((x_offset, y_offset), part, fill=current_fg, font=font)
                    
                    # Move x offset by the actual text width
                    x_offset += text_width
        
        y_offset += line_height
    
    img.save(output_file)

def strip_ansi_codes(text):
    """Remove ANSI escape codes from text"""
    import re
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape.sub('', text)

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
    
    # Generate color table previews using the contrib scripts
    generate_color_table_previews(root_dir)

if __name__ == '__main__':
    main()