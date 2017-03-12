
# Upgrade all python packages using a single pip
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

# Source: http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip