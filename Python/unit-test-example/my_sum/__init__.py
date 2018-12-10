def say_hello(name):
    if name != '':
        print('Hello, ' + name + '!')
    else:
        print('Hello there!')

    result = ('Hello, ' + name + '!')
    return result


def sum_int(arg):
    total = 0
    for val in arg:
        total += val
    return total
