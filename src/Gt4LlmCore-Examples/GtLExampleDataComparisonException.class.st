Class {
	#name : #GtLExampleDataComparisonException,
	#superclass : #Error,
	#instVars : [
		'expectedData',
		'actualData'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLExampleDataComparisonException >> actualData: aDataObject [ 
	actualData := aDataObject 
]

{ #category : #utils }
GtLExampleDataComparisonException >> computeDiff [
	^ GtDiffBuilder
			computeDifferencesFrom: expectedData printData 
			to: actualData printData
			using: GtCharacterGroupDiffSplitter words  ignoreWhitespace
]

{ #category : #'as yet unclassified' }
GtLExampleDataComparisonException >> expectedData: aDataObject [ 
	expectedData := aDataObject 
]

{ #category : #'gt-extensions' }
GtLExampleDataComparisonException >> gtViewDiffFor: aView [ 
	<gtView>
	<gtExceptionView>
	
	^ aView forward 
		title: 'Diff';
		priority: 1;
		object: [	
			self computeDiff ];
		view: #gtTextView:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect the comparator' 
			action: [ :aButton |
				aButton phlow spawnObject: self computeDiff ]
]

{ #category : #serialization }
GtLExampleDataComparisonException >> serializeToOpenAIResponseImages [
	^{(GtLPrimitiveImageData fromElement:  (self 
		gtViewDiffFor: GtPhlowView empty) asElement)}
]
