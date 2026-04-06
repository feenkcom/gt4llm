Class {
	#name : #GtLObjectWithADataJsonViewForTest,
	#superclass : #Object,
	#instVars : [
		'slotOne',
		'slotTwo'
	],
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #initialization }
GtLObjectWithADataJsonViewForTest >> initialize [ 
	super initialize.
	
	slotOne := 'AValue'.
	slotTwo := 42.
]

{ #category : #acessing }
GtLObjectWithADataJsonViewForTest >> jsonData [ 
	^Dictionary new 
				at: 'valueOne' put: 1;
				at: 'valueTwo' put: 2;
				yourself
]

{ #category : #'llm views' }
GtLObjectWithADataJsonViewForTest >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView 
			title: 'Exception generic details';
			jsonData: [ self jsonData ]
]
