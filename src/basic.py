class BasicClass:
    """Test class"""

    def add_string(self, string_1, string_2):
        """String function"""
        return string_1 + string_2

    def print_hello(self):
        """Print function"""
        string = self.add_string("Hello", " World")
        print(string)
