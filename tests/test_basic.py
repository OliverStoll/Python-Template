from src.basic import TestClass


def test_add():
    """Test add method"""
    test = TestClass()
    assert test.add_one(1) == 2


def test_add_string():
    """Test add string method"""
    test = TestClass()
    assert test.add_string("my") == "mytest"
