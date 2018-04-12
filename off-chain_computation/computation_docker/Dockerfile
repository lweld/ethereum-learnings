# 'FROM' starts a new build of a Docker container. It sets the parent image that
# everything else runs off of. 'python:3' allows our image to run python version 3.
FROM python:3

# Set the working directory to /computation_test
WORKDIR /computation_test

# Copy the current directory contents into the container at /computation_test
ADD . /computation_test

# 'RUN' is what is needed to run your program. 'pip install' is a package manager 
# to install/manage packages written in python. '--trusted-host pypi.python.org'
# is a repo of Python packages. '-r requirements.txt` says that packages specified
# in requirements.txt should be installed from the python repo.
RUN pip install --trusted-host pypi.org -r requirements.txt

# Provides the default for what should execute in our container. Python is the
# executable and computation_test.py is being executed by the executable.
CMD ["python", "computation_test.py"]