Class {
	#name : #GtLMethodsCompilationDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'as yet unclassified' }
GtLMethodsCompilationDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	(self methods anySatisfy: [:each | each isKindOf: GtLMethodCompilationExceptionDomainObject]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ GtSearchFixedMethodsFilter new methods: (self methods collect: #method) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLMethodsCompilationDomainObject >> gtMethodsListFor: aView [
	<gtView>
	<gtLlmView>
	methods ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Method list';
		priority: 2;
		items: [ methods ];
		column: 'Class' text: [ :each | each method gtDisplayString ];
		column: 'State'
			text: [ :each | each hasOldSourceCode ifTrue: [ 'Modified' ] ifFalse: [ 'New' ] ]
]

{ #category : #'as yet unclassified' }
GtLMethodsCompilationDomainObject >> gtMethodsWithExceptionsFor: aView [
	<gtView>
	<gtLlmView>
	(self methods noneSatisfy: [:each | each isKindOf: GtLMethodCompilationExceptionDomainObject]) ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Methods';
		priority: 1;
		items: [ self methods ];
		column: 'Kind' text: [:each | each class name ];
		column: 'Source' text: [ :each | each sourceCode ]
]

{ #category : #accessing }
GtLMethodsCompilationDomainObject >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodsCompilationDomainObject >> methods: aCollection [
	methods := aCollection
]

{ #category : #serialization }
GtLMethodsCompilationDomainObject >> serializeToOpenAIResponseJsonObject [
	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods' put: (self methods collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
