pipeline
{
    agent any

    stages
    {

        stage("Setup Environment")
        {
            steps
            {
                // Gives Premission To Run sh files
                sh(script:"chmod +x ./ci/Top/compile.sh", label: "Premission for Top")
            }
        }
        stage("Build")
        {
            steps
            {
                sh(script:"./ci/Top/compile.sh", label: "Compiling...")
            }
        }
        stage("Run")
        {
            steps
            {
                sh(script:"./ci/Top/top_module", label: "Running...")
            }
        }
    }
}