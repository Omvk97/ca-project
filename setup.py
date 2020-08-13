from setuptools import setup

setup(
   name='ca-project',
   version='1.0',
   description='A development project for experimentation with jenkins',
   author='Oliver',
   author_email='no@foo.com',
   packages=[''],  #same as name
   install_requires=['Flask==1.1.2','Flask-SQLAlchemy==2.4.4','Flask-WTF==0.14.3','xmlrunner==1.7.7'] #external packages as dependencies
)