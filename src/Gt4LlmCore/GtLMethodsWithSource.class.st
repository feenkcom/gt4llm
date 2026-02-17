Class {
	#name : #GtLMethodsWithSource,
	#superclass : #Object,
	#instVars : [
		'methods'
	],
	#category : #Gt4LlmCore
}

{ #category : #views }
GtLMethodsWithSource >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ GtSearchFixedMethodsFilter new methods: (self methods 
			collect: [ :each | each compiledMethod ]) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLMethodsWithSource >> gtViewMethodsListFor: aView [
	<gtView>
	^ aView forward
		title: 'Methods list';
		priority: 40;
		object: [ methods ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtLMethodsWithSource >> methods [
	^ methods
]

{ #category : #accessing }
GtLMethodsWithSource >> methods: aCollection [
	methods := aCollection
]

{ #category : #accessing }
GtLMethodsWithSource >> methodsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #methods;
			classes: {GtLMethodWithSource};
			beRequired
]
