Class {
	#name : #GtLRefactoringClassDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'targetClass'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt-llm - serialization' }
GtLRefactoringClassDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
			at: 'class' put: targetClass name asString;
			at: 'superclass'
				put: (targetClass superclass ifNil: [ nil ] ifNotNil: [ :spr | spr name asString ]);
			at: 'package' put: targetClass packageName asString;
			at: 'instanceSlots' put: targetClass instanceVariableNames asArray;
			at: 'classSlots' put: targetClass classSide instanceVariableNames asArray;
			at: 'allInstanceMethods' put: targetClass selectors asArray;
			at: 'allClassMethods' put: targetClass classSide selectors asArray ]
]

{ #category : #accessing }
GtLRefactoringClassDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLRefactoringClassDomainObject >> targetClass: anObject [
	targetClass := anObject
]
