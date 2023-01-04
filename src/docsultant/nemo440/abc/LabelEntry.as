package docsultant.nemo440.abc
{
		public final dynamic class LabelEntry
		{
			var count:int;
			
			public function labelFor(target:int):String
			{
				if (target in this)
					return this[target];
				return this[target] = "L" + (++count);
			}
		}
}