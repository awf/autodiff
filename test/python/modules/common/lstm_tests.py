import unittest
import numpy as np
import sys
import os

# root directory of the whole project
ROOT = os.path.abspath(os.path.join(
    os.path.abspath(os.path.dirname(__file__)),
    "..",
    "..",
    "..",
    ".."
))

# root directory of the python source
PYTHON_ROOT = os.path.join(ROOT, "src", "python")

# adding python src root directory for importing
sys.path.append(PYTHON_ROOT)

from runner.ModuleLoader import module_load
from shared.input_utils import read_lstm_instance
import utils



# root directory of python modules
MODULES_ROOT = os.path.join(PYTHON_ROOT, "modules")

# path to the file with test data input
TEST_INPUT_FILE_NAME = os.path.join(ROOT, "data", "lstm", "lstm_l2_c1024.txt")



# Parameters for different modules. They have the following form:
# {
#   "path": <module path relative to src/python/modules directory>,
#   "tolerance": <tolerance for module output results>
# }
test_params = [
    {
        "path": os.path.join("PyTorch", "PyTorchLSTM.py"),
        "tolerance": 1e-8
    },
    {
        "path": os.path.join("Tensorflow", "TensorflowLSTM.py"),
        "tolerance": 1e-8
    }
]



class PythonModuleCommonLSTMTests(utils.BaseTestClass):
    '''Checking LSTM objective differentiation in all python modules.''' 

    # helping functions
    def objective_calculation_correctness(self, times):
        '''Checks objective calculation correctness running calculation
        several times.'''

        input = read_lstm_instance(TEST_INPUT_FILE_NAME)
        self.test.prepare(input)
        self.test.calculate_objective(times)
        output = self.test.output()

        self.assertFloatEqual(
            0.66666518,
            output.objective,
            self.params["tolerance"]
        )

    def jacobian_calculation_correctness(self, times):
        '''Checks jacobian calculation correctness running calculation
        several times.'''

        input = read_lstm_instance(TEST_INPUT_FILE_NAME)
        self.test.prepare(input)
        self.test.calculate_jacobian(times)
        output = self.test.output()

        expected_gradient = [
            3.14387024996101187e-06,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            -3.67840807336070475e-05,
            -1.54848612683180522e-04,
            5.48717267869773910e-06,
            -4.04527413533285253e-06,
            -8.77353908686236070e-07,
            -1.81973718092835457e-06,
            -6.61404620766666418e-07,
            1.25432314145999742e-04,
            5.26459549995064566e-06,
            3.42833197850334681e-06,
            2.79076684010150125e-05,
            4.45603055235501376e-05,
            4.04185405141412220e-05,
            1.13487138666022078e-05,
            -7.36119414163935681e-05,
            -3.92318596883106641e-04,
            6.03607595779890245e-06,
            -2.50749024433336479e-05,
            -4.83955404587018941e-06,
            -4.94175793354897013e-06,
            -1.49848451794559008e-06,
            4.01789457601843220e-06,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            -6.16501771215585166e-05,
            -2.14471058586458561e-04,
            5.56661202545761896e-06,
            -5.22021372686648383e-06,
            -1.95401365542668346e-06,
            -4.68776054707821880e-06,
            -2.67879854428802963e-06,
            8.49896476968742872e-04,
            2.14480696808520274e-04,
            1.27240956373907973e-04,
            1.03380278076147588e-04,
            3.26983387274766885e-05,
            1.47321495437521366e-04,
            2.03767485364521309e-05,
            -1.71027241883012373e-04,
            -9.97102906947628905e-04,
            1.05573445256271496e-04,
            -4.10813160791978987e-05,
            -4.66363145389210376e-06,
            -5.61458724856520127e-06,
            -1.72719535440704236e-06,
            7.41562400488615767e-04,
            1.35905892236421730e-04,
            9.18319427682989299e-05,
            1.14039861417365726e-04,
            1.31037490514354042e-04,
            1.89958003915723621e-04,
            6.66667089111214168e-05,
            -2.99753093683376040e-04,
            -1.39428488543169235e-03,
            7.81997486731591678e-05,
            -7.11003463557882681e-05,
            -1.56689414959509608e-05,
            -1.59132673852719420e-05,
            -5.88701856095873723e-06,
            3.65214776221949554e-04,
            1.08440867176087962e-04,
            6.75251197117822909e-05,
            5.07904844905876160e-05,
            6.94964603070496247e-05,
            9.71513382958139477e-05,
            2.40897410354102865e-05,
            -1.31891358419510490e-04,
            -7.36772740642002493e-04,
            4.48757608883305795e-05,
            -4.51743229379305454e-05,
            -7.63715831354149397e-06,
            -8.36900345795258848e-06,
            -2.41858043904271068e-06,
            8.00930878140701909e-04,
            8.05738754618121506e-05,
            7.04205639535801850e-05,
            1.34615500556859374e-04,
            2.07383290113708586e-04,
            2.94203848388590759e-04,
            2.08296283404346797e-04,
            -5.00619564307732703e-04,
            -1.90384053275097134e-03,
            6.83889421204583172e-05,
            -8.85415990620916452e-05,
            -4.01278522469193820e-05,
            -3.19293895829058307e-05,
            -2.48575295654621768e-05,
            2.47822472805507175e-03,
            5.07502578529807780e-03,
            2.53859920727141910e-03,
            1.88350319998056696e-04,
            5.10157230919509725e-05,
            3.54335963584264193e-04,
            4.32702650224108475e-05,
            -3.06537980830570744e-04,
            -1.87256106103047193e-03,
            7.86527299400905083e-04,
            -7.40280147056494078e-05,
            -7.36222276800657044e-06,
            -9.51938152613299431e-06,
            -2.78936845972344488e-06,
            5.38571851736894072e-04,
            4.12509633131798620e-05,
            6.47788903296268593e-05,
            3.76860255482900047e-04,
            1.00145332877384172e-03,
            2.29657803047558681e-04,
            4.44627297218581029e-04,
            -9.73952035222110210e-04,
            -4.51211367568013846e-03,
            1.41925554887538418e-04,
            -1.66675086094364628e-05,
            -2.28915871203058926e-05,
            -6.90861176975165640e-05,
            -2.81513790989548166e-04,
            2.53531909024735675e-04,
            2.91530880231834222e-04,
            2.87839568382086426e-04,
            6.61417346851010207e-05,
            6.11690024226054017e-04,
            1.08165251111585849e-04,
            9.94833840089197921e-05,
            -5.39732825546851164e-04,
            -1.95313692267145384e-03,
            2.87262803065020395e-04,
            -6.42028361615228470e-06,
            -6.81225636233755266e-06,
            -3.58438396937832646e-05,
            -1.41607977576401395e-04,
            9.90063334626659942e-04,
            6.71457692678222891e-05,
            9.64171460882922153e-05,
            2.83657185457934097e-04,
            1.41431021522050158e-03,
            7.42601545855336369e-04,
            1.63135992873617838e-04,
            -1.80905573085369175e-03,
            -5.78938583485935632e-03,
            1.08933179139588087e-04,
            -2.82053334001221257e-04,
            -1.58448932394055300e-04,
            -1.62053197372598410e-04,
            -4.44062656277905885e-04,
            1.23784405389406552e-03,
            3.70797204635395672e-04,
            8.95872992208362269e-04,
            9.54650103551505725e-04,
            7.94492683033071450e-04,
            1.33045599071493839e-04,
            1.90972131022078425e-03,
            -1.27723370300947075e-03,
            -7.98761497515965146e-03,
            1.31804902759735014e-03,
            -1.18749502523366873e-05,
            -1.17265333639628955e-05,
            -5.72852084344175575e-05,
            -1.76267731147033947e-04,
            1.57111882911252715e-03,
            9.63872765804848195e-04,
            1.29692708705586861e-03,
            6.85018812295237929e-04,
            1.56084730076406770e-03,
            5.51507203835322228e-04,
            9.44664300904442429e-04,
            -1.74595527620669054e-03,
            -8.47272040239691569e-03,
            1.06146398161773513e-03,
            -3.01166484114288631e-05,
            -3.61150963335128990e-05,
            -1.17040277318999298e-04,
            -4.53714566010890040e-04,
            4.83883598142451641e-04,
            5.36532886336024261e-04,
            7.10491025781043260e-04,
            4.03370948422198858e-04,
            9.21362107223384799e-04,
            1.83544588672272390e-04,
            5.84842906913008364e-04,
            -9.12226698645542925e-04,
            -3.71928760349100754e-03,
            5.24341732641706525e-04,
            -8.78104574502159225e-06,
            -9.40356235117202346e-06,
            -6.16753351894278713e-05,
            -2.59729129852274867e-04,
            2.88643409216300618e-03,
            1.56939967321338843e-03,
            1.92928469338899343e-03,
            5.15538874537588353e-04,
            2.20418224227594915e-03,
            1.78306235870001779e-03,
            3.46590677977152962e-04,
            -3.24323971790235277e-03,
            -1.08700028019174302e-02,
            8.13601709951329772e-04,
            -5.09026696834261072e-04,
            -2.50224828500900109e-04,
            -2.74229202243154427e-04,
            -7.15862244954266883e-04,
            2.36221822129175068e-03,
            6.82455302403955932e-04,
            2.21184971904590886e-03,
            5.81458374769466737e-03,
            1.19699412544996883e-03,
            2.26008787507052335e-04,
            1.12207195875873196e-02,
            -2.15943584477549123e-03,
            -1.52105422913329149e-02,
            2.40692059621100754e-03,
            -1.62908509623434489e-05,
            -1.62307954324598644e-05,
            -9.93149651364052892e-05,
            -3.23349485361925845e-04,
            8.95056656284422921e-06,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            -1.73683965955792591e-04,
            -3.21979564391077671e-04,
            7.71925547683623476e-06,
            -2.98807224102069401e-05,
            -1.11738854533001905e-05,
            -2.92505411923477579e-06,
            -2.04187281292674588e-06,
            1.14042748169088035e-02,
            9.93947389065250562e-03,
            4.53876797372907911e-03,
            1.46753585074672422e-03,
            1.59578501610211192e-02,
            7.13215996147348839e-03,
            2.52120644391976836e-03,
            -1.79990239825079217e-02,
            -2.62659614088943671e-02,
            2.44293992080160194e-03,
            -3.67074714937877696e-03,
            -1.31444481103537205e-02,
            -4.54999892021307108e-03,
            -1.09270983790279372e-02,
            2.17348662792538061e-02,
            1.82857375496154884e-02,
            1.11887441899222798e-02,
            8.97672919990902263e-03,
            2.39853893219980456e-02,
            1.20800375241284126e-02,
            1.48638788575309582e-02,
            -3.02324690101714345e-02,
            -5.00116775406580991e-02,
            4.46620942840666828e-03,
            -5.23602406001136191e-03,
            -1.79316285235904226e-02,
            -7.73167106472800580e-03,
            -2.00225690895980656e-02
        ]

        self.assertFloatArrayEqual(
            expected_gradient,
            output.gradient,
            self.params["tolerance"]
        )



    # main test functions
    def setUp(self):
        module_path = os.path.join(MODULES_ROOT, self.params["path"])
        self.test = module_load(module_path)
        self.assertIsNotNone(self.test)

    def test_loading(self):
        '''Checks if modules can be loaded.'''

        pass    # all work is done in the setUp function

    def test_objective_calculation_correctness(self):
        '''Checks correctness of objective calculation over the single run.'''

        self.objective_calculation_correctness(times = 1)

    def test_objective_multiple_times_calculation_correctness(self):
        '''Checks correctness of objective calculation over several runs.'''

        self.objective_calculation_correctness(times = 3)

    def test_jacobian_calculation_correctness(self):
        '''Checks correctness of jacobian calculation over the single run.'''

        self.jacobian_calculation_correctness(times = 1)

    def test_jacobian_multiple_times_calculation_correctness(self):
        '''Checks correctness of jacobian calculation over several runs.'''

        self.jacobian_calculation_correctness(times = 3)

    def test_objective_runs_multiple_times(self):
        '''Checks if objective can be calculated multiple times.'''

        input = read_lstm_instance(TEST_INPUT_FILE_NAME)
        self.test.prepare(input)

        func = self.test.calculate_objective
        self.assertTrue(utils.can_objective_run_multiple_times(func))

    def test_jacobian_runs_multiple_times(self):
        '''Checks if jacobian can be calculated multiple times.'''

        input = read_lstm_instance(TEST_INPUT_FILE_NAME)
        self.test.prepare(input)

        func = self.test.calculate_jacobian
        self.assertTrue(utils.can_objective_run_multiple_times(func))



if __name__ == "__main__":
    suite = unittest.TestSuite()
    for param_set in test_params:
        suite.addTest(utils.ParametrizedTestClass.parametrize(
            PythonModuleCommonLSTMTests,
            params = param_set
        ))

    res = unittest.TextTestRunner(verbosity = 2).run(suite)
    if res.wasSuccessful():
        sys.exit(0)
    else:
        sys.exit(1)