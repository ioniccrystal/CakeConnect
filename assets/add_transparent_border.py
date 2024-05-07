from PIL import Image

def add_transparent_border(input_image_path, output_image_path, border_size):
    """
    为图像添加透明边缘。
    
    :param input_image_path: 输入图像的路径
    :param output_image_path: 带有透明边缘的输出图像的路径
    :param border_size: 边缘大小（像素）
    """
    # 打开原始图像
    with Image.open(input_image_path) as img:
        # 获取原始图像的尺寸
        width, height = img.size
        
        # 计算新图像的尺寸
        new_width = width + 2 * border_size
        new_height = height + 2 * border_size
        
        # 创建一个新的图像，模式为RGBA（包括透明通道），并填充为透明
        new_image = Image.new('RGBA', (new_width, new_height), (0, 0, 0, 0))
        
        # 将原始图像粘贴到新图像的中心
        new_image.paste(img, (border_size, border_size))
        
        # 保存新图像
        new_image.save(output_image_path)

# 使用函数的示例
input_path = 'Triangle.png'  # 替换为你的输入图像路径
output_path = 'triangle_with_transparent_border.png'  # 替换为你的输出图像路径
border_size = 10  # 边缘大小（像素）

add_transparent_border(input_path, output_path, border_size)