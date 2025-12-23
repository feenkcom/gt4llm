Class {
	#name : #GtLCodeTransformations,
	#superclass : #Object,
	#instVars : [
		'transformations'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #views }
GtLCodeTransformations >> gtViewTransformationsFor: aView [
	<gtView>
	transformations ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Transformations';
		priority: 10;
		items: [ transformations ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #printing }
GtLCodeTransformations >> printOn: aStream [
	super printOn: aStream.

	aStream 
		<< ' [';
		print: self transformations size;
		<< ' ';
		<< (self transformations size = 1 
			ifTrue: [ 'transformation' ]
			ifFalse: [ 'transformations' ]);
		<< ']'
]

{ #category : #accessing }
GtLCodeTransformations >> transformations [
	^ transformations
]

{ #category : #accessing }
GtLCodeTransformations >> transformations: anObject [
	transformations := anObject
]

{ #category : #accessing }
GtLCodeTransformations >> transformationsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #transformations;
			classes: {GtLAddClassSpecification . GtLAddMethodSpecification};
			beRequired
]
