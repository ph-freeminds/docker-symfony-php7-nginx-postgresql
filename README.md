# docker-symfony5-php7-nginx-postgresql

Hi ! Whoever you are ..

I spent a LOT of time to find a way to build this specific environment. I found a lot of Github repositories, tutorials, and many other shit that didn't works..
Finally, I did it myself and, here it is ! it works.

So, here a simple repo containing docker sources to build an php7, nginx and postgresql environment to run a symfony 5 project.

# First
Clone or download this project and move docker folder and docker-compose.yaml to your project root directory

# Second
run `docker-compose up`

# Third
Take a coffee while docker installing all this stuff ( maybe two, depend on your internet connexion x) )

# Fourth
Open your favorite browser ( which is not Google Chrome ) go to `localhost:8080` and holy s**t, it works !


I also put a small `Makefile` file containing `make` commands I often use but you can remove it if you don't need it.

I hope it will help you, See you ! ( We both know that we will not meet each other )
