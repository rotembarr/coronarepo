
        stage("Setup Environment")
        {
            steps
            {
                // Gives Premission To Run sh files
                sh(script:"chmod +x ./ci/First_Module/compile.sh", label: "Premission for First_Module")
            }
        }
        stage("Build")
        {
            steps
            {
                sh(script:"./ci/First_Module/compile.sh", label: "Compiling...")
            }
        }
        stage("Run")
        {
            steps
            {
                sh(script:"./ci/First_Module/first_module", label: "Running...")
            }
        }
