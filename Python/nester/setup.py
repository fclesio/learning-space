from distutils.core import setup

setup(
    name='nester',
    version='1.0.0',
    py_modules=['nester'],
    author='flavioclesio',
    author_email='clesio@flavioclesio.com',
    url='http://www.flavioclesio.com',
    description='Work with nested lists',
)

# 1) Build the distribution: $ python setup.py sdist
# 2) Install the dependency in local python: $ python setup.py install
