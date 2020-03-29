
        stage("Setup Environment")
        {
                // Gives Premission To Run sh files
                sh(script:"chmod +x ./ci/Top/compile.sh", label: "Premission for Top")
        }
        stage("Build")
        {
                sh(script:"./ci/Top/compile.sh", label: "Compiling...")
        }
        stage("Run")
        {
                sh(script:"./ci/Top/top_module", label: "Running...")
        }
