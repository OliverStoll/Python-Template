from src.basic import BasicClass


def test_add_string():
    """Test add string method"""
    test = BasicClass()
    assert test.add_string("my", "test") == "mytest"
