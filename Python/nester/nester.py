def print_lol(the_list):
    """
    Summary.

    Extract values from a deep nested list.

    Parameters
    ----------
    the_list : list
        List with some values to be unested

    Returns
    -------
    values
        Values of the list, even if nested or not

    """
    for each_item in the_list:
        if isinstance(each_item, list):
            print_lol(each_item)
    else:
        print(each_item)
