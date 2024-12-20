import EasyMCP2221
from time import sleep

mcp = EasyMCP2221.Device()

mcp.set_pin_function(gp0 = "GPIO_OUT")

while True:
    # Encender
    mcp.GPIO_write(gp0 = 1)
    sleep(1)

    # Apagar
    mcp.GPIO_write(gp0 = 0)
    sleep(1)