part of dotdotcommadot_benchmarker;

class Benchmarker
{
  //-----------------------------------
  //
  // Private Static Properties
  //
  //-----------------------------------
	
	static bool _disabled 															= false;
	static Stopwatch _stopwatch 												= new Stopwatch();
	static Map<String, List<Benchmark>> _benchmarks 		= new Map();
	
  //-----------------------------------
  //
  // Public Static Methods
  //
  //-----------------------------------
	
	static void disable()
	{
		_disabled = true;
	}
	
	/***
	 * Returns a new Benchmark, if Benchmarker.disabled is false.
	 * Returns an empty Benchmark if Benchmarker.disabled is true.
	 */
	static Benchmark generate(String name, {int indentation, bool autoRun: true, String group: 'DEFAULT'})
	{
		if (_disabled)
			return new NullBenchmark();
    		
		if (!_stopwatch.isRunning)
			_stopwatch.start();
		
		if (_benchmarks[group] == null)
			_benchmarks[group] = new List();
		
		Benchmark benchmark = new Benchmark('[$group] $name', _stopwatch, indentation: indentation);
		_benchmarks[group].add(benchmark);
		
		if (autoRun == true)
			benchmark.start();
		
		return benchmark;
	}
		
	/***
	 * Generates a report for the given group.
	 * If no group is specified, the default group is selected
	 */
	static void report({String group: 'DEFAULT'})
	{
		if (_disabled)
		{
			print("Enable benchmarks to produce a report");
			return;
		}
		
		if (_benchmarks[group] == null)
		{
			print("No benchmarks were found for the $group group");
			return;
		}
		
		List runningBenchmarks = _benchmarks[group].where((B) => B.isRunning == true).toList();
		if (runningBenchmarks != null && runningBenchmarks.length > 0)
		{
			print("Could not generate a report, because following benchmarks are still running: ");
			runningBenchmarks.forEach((B) => print('${B.identifier.toString()}'));
			return;
		}
		
		_benchmarks[group].forEach((B) => B.report());
		
		_benchmarks.remove(group);
		_stopwatch = new Stopwatch();
	}
}