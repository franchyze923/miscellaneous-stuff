import ctypes

def define_c_struct(c_struct_definition):
    """
    Dynamically define a C struct in Python using ctypes from a C-style definition string.
    
    :param c_struct_definition: A string containing the C struct definition.
    :return: A Python class representing the C struct.
    """
    lines = c_struct_definition.strip().split("\n")
    struct_name = lines[0].split()[-1]  # Get the struct name (e.g., 'MyStruct')
    fields = []

    for line in lines[1:]:
        line = line.strip().strip(";")  # Remove leading/trailing whitespace and semicolon
        if not line or line == "}":
            continue  # Skip empty lines and closing brace
        c_type, field_name = line.rsplit(" ", 1)  # Split into type and field name
        field_name = field_name.strip()  # Clean up field name
        c_type = c_type.strip()  # Clean up C type

        # Map C types to ctypes
        ctype_map = {
            "int": ctypes.c_int,
            "float": ctypes.c_float,
            "double": ctypes.c_double,
            "char": ctypes.c_char,
            "char*": ctypes.c_char_p,
            "void*": ctypes.c_void_p,
        }

        if c_type in ctype_map:
            fields.append((field_name, ctype_map[c_type]))
        else:
            raise ValueError(f"Unsupported C type: {c_type}")

    # Dynamically create a ctypes.Structure subclass
    return type(struct_name, (ctypes.Structure,), {"_fields_": fields})


# Example C struct string
c_struct = """
struct MyStruct {
    int a;
    float b;
    char c;
    char* d;
};
"""

# Define the struct
MyStruct = define_c_struct(c_struct)

# Use the struct
my_struct = MyStruct(a=1, b=2.5, c=b'A', d=b"Hello")

# Access fields
print(my_struct.a)  # Output: 1
print(my_struct.b)  # Output: 2.5
print(my_struct.c)  # Output: b'A'
print(my_struct.d)  # Output: b'Hello'