Class {
	#name : #GtLCodeTransformationSpecification,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLCodeTransformationSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> asRefactoring [
	| namespace |
	namespace := GtRBNamespace new.
	^ self asRefactoringIn: namespace.
]

{ #category : #'as yet unclassified' }
GtLCodeTransformationSpecification >> asRefactoringIn: aNamespace [
	^ self subclassResponsibility
]

{ #category : #views }
GtLCodeTransformationSpecification >> gtChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Changes';
		object: [ self namespaceWithAppliedRefactoring ];
		view: #gtApplyingChangesFor:
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> namespaceWithAppliedRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	composite primitiveExecute.
	^ namespace
]
