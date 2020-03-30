/*pipeline
{
    agent any

    stages
    {
*/
        stage("Build")
        {
            sh(script:"./ci/First_Module/compile.sh", label: "Compiling...")
        }
        stage("Run")
        {
            sh(script:"./ci/First_Module/first_module", label: "Running...")
        }
/*    }
}*/