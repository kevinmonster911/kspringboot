## kspring boot (spring boot jpa hibernate with docker)
this project reference some code from other people(just integrate for describe
how to use spring boot with docker)

### Usage

- Run the application and go on http://localhost:8080/
- Use the following urls to invoke controllers methods and see the interactions
  with the database:
    * `/user/save?email=[email]&name=[name]`: create a new user with an 
      auto-generated id and email and name as passed values.
    * `/user/delete?id=[id]`: delete the user with the passed id.
    * `/user/get-by-email?email=[email]`: retrieve the id for the user with the
      passed email address.

### Build and run

#### Configurations

Open the `application.properties` file and set your own configurations for the
database connection.

#### Prerequisites

- Java 7+
- Maven 3
- docker

#### From terminal

Go on the project's root folder, then type:

    $ mvn spring-boot:run

