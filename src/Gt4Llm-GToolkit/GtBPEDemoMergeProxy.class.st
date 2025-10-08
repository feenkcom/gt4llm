Class {
	#name : #GtBPEDemoMergeProxy,
	#superclass : #PBProxyObject,
	#category : #'Gt4Llm-GToolkit-BPE'
}

{ #category : #accessing }
GtBPEDemoMergeProxy class >> pythonClass [
	^ 'gtoolkit_bridge.PythonBridge.python_bridge.BPEMerge'
]

{ #category : #accessing }
GtBPEDemoMergeProxy >> gtBeforeAndAfterFor: aView [
	<gtView>
	^ aView explicit
		title: 'Before and after';
		priority: 1;
		stencil: [ BrHorizontalPane new matchParent
				addChild: (GtLlmTokenizedStringEditor new
						decorationBlock: [ :aNameLabel :aNumberLabel :aToken :anIndex | 
							(self replacedIndices includes: anIndex)
								ifTrue: [ aNameLabel background: BrGlamorousColors newsBackgroundColor.
									aNumberLabel background: BrGlamorousColors newsBackgroundColor ] ];
						result: self before_text;
						background: Color white;
						addAptitude: BrShadowAptitude;
						padding: (BlInsets all: 5));
				addChild: (GtLlmTokenizedStringEditor new
						decorationBlock: [ :aNameLabel :aNumberLabel :aToken :anIndex | 
							aToken number = self number
								ifTrue: [ aNameLabel background: BrGlamorousColors newsBackgroundColor.
									aNumberLabel background: BrGlamorousColors newsBackgroundColor ] ];
						result: self after_text;
						padding: (BlInsets all: 5)) ]
]

{ #category : #accessing }
GtBPEDemoMergeProxy >> replacedIndices [
	"we return the indices of both parts of the replaced pair. Python is 0-indexed, Pharo 1-indexed, so we need to increment the numbers"
	^ self performed_merges
		flatCollect: [ :aTuple | 
			{aTuple first + 1.
				aTuple first + 2} ]
]
