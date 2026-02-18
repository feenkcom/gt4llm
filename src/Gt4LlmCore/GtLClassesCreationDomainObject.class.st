Class {
	#name : #GtLClassesCreationDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'classes'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLClassesCreationDomainObject >> classes [
	^ classes ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassesCreationDomainObject >> classes: aCollection [
	classes := aCollection
]

{ #category : #views }
GtLClassesCreationDomainObject >> gtClassesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Classes';
		priority: 1;
		items: [ self classes ];
		column: 'Class' text: [ :each | each originalClassName ];
		column: 'Superclass' text: [ :each | each originalSuperclassName ]
]

{ #category : #accessing }
GtLClassesCreationDomainObject >> serializeToOpenAIResponseJsonObject [
	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'classes' put: (self classes collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
