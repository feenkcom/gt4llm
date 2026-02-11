Class {
	#name : #GtLMethodsCompilationDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLMethodsCompilationDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ GtSearchFixedMethodsFilter new methods: (self methods collect: #method) ];
		view: #gtItemsFor:
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
