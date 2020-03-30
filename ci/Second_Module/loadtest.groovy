pipeline
{
    agent any

    stages
    {

        stage("Build")
        {
                steps{
                        sh(script:"./ci/Second_Module/compile.sh", label: "Compiling...")
                }
        }
        stage("Run")
        {
                steps{
                        sh(script:"./ci/Second_Module/second_module", label: "Running...")
                }
        }
    }
}