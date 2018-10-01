#!/bin/sh -xe

                cd ..
                git init
                git config --global user.name "Administrator"
                git config --global user.email "admin@example.com"
                git pull origin integration
                git add --all
                git commit -m "Added myproject to Github"
                git push https://viveksrivastv:github123@github.com/viveksrivastv/test-repo.git --all
                