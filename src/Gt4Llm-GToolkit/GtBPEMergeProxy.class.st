Class {
	#name : #GtBPEMergeProxy,
	#superclass : #PBProxyObject,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtBPEMergeProxy class >> pythonClass [
	^ 'tokenization.BPEMerge'
]

{ #category : #accessing }
GtBPEMergeProxy >> gtBeforeAndAfterFor: aView [
	<gtView>
	^ aView explicit
		title: 'Before and after';
		priority: 1;
		stencil: [ BrHorizontalPane new matchParent
				margin: (BlInsets all: 10);
				addChild: (BrVerticalPane new matchParent
						addChild: (BrLabel new
								text: 'Before';
								margin: (BlInsets left: 10);
								aptitude: (BrGlamorousLabelAptitude new foreground: Color gray));
						addChild: (GtLlmTokenizedStringEditor new
								decorationBlock: [ :aNameLabel :aNumberLabel :aToken :anIndex | 
									(self replacedIndices includes: anIndex)
										ifTrue: [ aNameLabel background: BrGlamorousColors newsBackgroundColor.
											aNumberLabel background: BrGlamorousColors newsBackgroundColor ] ];
								result: self before_text;
								background: Color white;
								addAptitude: BrShadowAptitude;
								margin: (BlInsets top: 5 left: 10 bottom: 10 right: 10)));
				addChild: (BrVerticalPane new matchParent
						addChild: (BrLabel new
								text: 'After';
								margin: (BlInsets left: 10);
								aptitude: (BrGlamorousLabelAptitude new foreground: Color gray));
						addChild: (GtLlmTokenizedStringEditor new
								decorationBlock: [ :aNameLabel :aNumberLabel :aToken :anIndex | 
									aToken number = self number
										ifTrue: [ aNameLabel background: BrGlamorousColors newsBackgroundColor.
											aNumberLabel background: BrGlamorousColors newsBackgroundColor ] ];
								result: self after_text;
								background: Color white;
								addAptitude: BrShadowAptitude;
								margin: (BlInsets top: 5 left: 10 bottom: 10 right: 10))) ]
]

{ #category : #accessing }
GtBPEMergeProxy >> replacedIndices [
	"we return the indices of both parts of the replaced pair. Python is 0-indexed, Pharo 1-indexed, so we need to increment the numbers"
	^ self performed_merges
		flatCollect: [ :aTuple | 
			{aTuple first + 1.
				aTuple first + 2} ]
]
