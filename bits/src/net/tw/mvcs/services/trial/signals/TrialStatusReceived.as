package net.tw.mvcs.services.trial.signals {
	
	import net.tw.mvcs.services.trial.vo.SharifyTrialStatus;
	
	import org.osflash.signals.Signal;
	
	public class TrialStatusReceived extends Signal {
		public function TrialStatusReceived() {
			super(SharifyTrialStatus);
		}
	}
}