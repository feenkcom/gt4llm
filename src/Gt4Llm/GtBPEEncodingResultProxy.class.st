Class {
	#name : #GtBPEEncodingResultProxy,
	#superclass : #PBProxyObject,
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtBPEEncodingResultProxy class >> pythonClass [
	^ 'gtoolkit_bridge.PythonBridge.python_bridge.EncodingResult'
]

{ #category : #accessing }
GtBPEEncodingResultProxy >> gtHistoryFor: aView [
	<gtView>
	^ aView columnedList
		priority: 1;
		title: 'History';
		items: [ self merges ];
		column: 'From pair' text: [ :aMerge | ', ' join: aMerge pair ];
		column: 'To byte' text: #byte;
		send: [ :aMerge | 
			GtDiffBuilder
				computeDifferencesFrom: (' ' join: (aMerge before_text collect: #byte))
				to: (' ' join: (aMerge after_text collect: #byte))
				using: GtCharacterGroupDiffSplitter words ]
]
