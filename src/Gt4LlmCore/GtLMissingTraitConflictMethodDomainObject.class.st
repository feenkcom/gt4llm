"
I am an error result for a method that several traits define, so that the requested class gets an unresolved conflict instead of a method. #conflictingMethodReferences names the conflicting methods of the traits. When the traits do not conflict in the requested class itself but in a superclass or in a used trait composed of other traits, #conflictLocationReference names the method there.
"
Class {
	#name : #GtLMissingTraitConflictMethodDomainObject,
	#superclass : #GtLMissingDomainObject,
	#instVars : [
		'conflictingMethodReferences',
		'conflictLocationReference'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #private }
GtLMissingTraitConflictMethodDomainObject class >> compositionElementsOf: aTraitComposition [
	^ (aTraitComposition isKindOf: TaSequence)
		ifTrue: [ aTraitComposition members ]
		ifFalse: [ {aTraitComposition} ]
]

{ #category : #private }
GtLMissingTraitConflictMethodDomainObject class >> conflictLocationOf: aConflict [
	"A conflict with a single provider was copied from it; follow it to where the traits actually conflict"

	| aProviders aMethod |
	aProviders := self providersOf: aConflict selector in: aConflict methodClass.
	aProviders size = 1 ifFalse: [ ^ aConflict ].
	aMethod := aProviders first compiledMethodAt: aConflict selector.
	^ aMethod isConflict
		ifTrue: [ self conflictLocationOf: aMethod ]
		ifFalse: [ aConflict ]
]

{ #category : #private }
GtLMissingTraitConflictMethodDomainObject class >> conflictingMethodsOf: aSelector in: aBehavior [
	^ (self providersOf: aSelector in: aBehavior)
		collect: [ :each | each compiledMethodAt: aSelector ]
]

{ #category : #'instance creation' }
GtLMissingTraitConflictMethodDomainObject class >> methodReference: aMethodReference conflict: aConflict [
	| aLocation aConflictingReferences |
	aLocation := self conflictLocationOf: aConflict.
	aConflictingReferences := ((self
			conflictingMethodsOf: aLocation selector
			in: aLocation methodClass)
			collect: [ :each | GtLMethodReference fromDefinitionOf: each ])
			asOrderedCollection.
	aConflictingReferences removeDuplicates.
	^ self new
		objectName: aMethodReference methodSignature;
		conflictingMethodReferences: aConflictingReferences asArray;
		conflictLocationReference: (aLocation methodClass == aMethodReference methodClass
				ifTrue: [ nil ]
				ifFalse: [ GtLMethodReference fromCompiledMethod: aLocation ]);
		yourself
]

{ #category : #private }
GtLMissingTraitConflictMethodDomainObject class >> providersOf: aSelector in: aBehavior [
	"A required method (an explicit requirement or a subclass responsibility) gives way to the method of another element, so it does not take part in a conflict"

	^ (self compositionElementsOf: aBehavior traitComposition)
		select: [ :each | 
			(each selectors includes: aSelector)
				and: [ (each compiledMethodAt: aSelector) isRequired not ] ]
]

{ #category : #accessing }
GtLMissingTraitConflictMethodDomainObject >> conflictLocationReference [
	^ conflictLocationReference
]

{ #category : #accessing }
GtLMissingTraitConflictMethodDomainObject >> conflictLocationReference: aMethodReference [
	conflictLocationReference := aMethodReference
]

{ #category : #descriptions }
GtLMissingTraitConflictMethodDomainObject >> conflictLocationReferenceDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Where the traits conflict';
		accessor: #conflictLocationReference;
		classes: {GtLMethodReference}
]

{ #category : #accessing }
GtLMissingTraitConflictMethodDomainObject >> conflictingMethodReferences [
	^ conflictingMethodReferences ifNil: [ #() ]
]

{ #category : #accessing }
GtLMissingTraitConflictMethodDomainObject >> conflictingMethodReferences: aCollectionOfMethodReferences [
	conflictingMethodReferences := aCollectionOfMethodReferences
]

{ #category : #descriptions }
GtLMissingTraitConflictMethodDomainObject >> conflictingMethodReferencesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Conflicting method references';
		accessor: #conflictingMethodReferences;
		classes: {GtLMethodReference};
		beRequired
]

{ #category : #accessing }
GtLMissingTraitConflictMethodDomainObject >> defaultErrorMessage [
	| conflictingSignatures |
	conflictingMethodReferences isEmptyOrNil
		ifTrue: [ ^ super defaultErrorMessage ].
	conflictingSignatures := ', '
			join: (conflictingMethodReferences collect: [ :each | each methodSignature ]).
	conflictLocationReference
		ifNotNil: [ ^ '{1} is not defined in its own class: it comes from {2}, where several traits conflict ({3}). Define it in the class, or resolve the conflict at {2}.'
				format: {self missingObjectName.
						conflictLocationReference methodSignature.
						conflictingSignatures} ].
	^ '{1} is not defined in its own class: it is provided by several traits that conflict ({2}). Define it in the class, or exclude it from all but one of the traits.'
		format: {self missingObjectName.
				conflictingSignatures}
]
