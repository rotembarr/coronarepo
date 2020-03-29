
        stage("Setup Environment")
        {
                // Gives Premission To Run sh files
                sh(script:"chmod +x ./ci/Second_Module/compile.sh", label: "Premission for Second_Module")
        }
        stage("Build")
        {
                sh(script:"./ci/Second_Module/compile.sh", label: "Compiling...")
        }
        stage("Run")
        {
                sh(script:"./ci/Second_Module/second_module", label: "Running...")
        }
