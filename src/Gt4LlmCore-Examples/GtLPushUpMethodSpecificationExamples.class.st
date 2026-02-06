Class {
	#name : #GtLPushUpMethodSpecificationExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : 'Gt4LlmCore-Examples-Formats'
}

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecificationExamples >> pushUpWithExistingSubclassAndSuperclass [
	<gtExample>
	| specification namespace |
	specification := GtLPushUpMethodSpecification new
			methodNameToPushUp: #initialize;
			methodClassName: DiffPatchVisitor name;
			targetClassName: DiffVisitor name.
	namespace := specification namespaceWithAppliedRefactoring.
	self assert: namespace changes changesSize > 0.
	^ specification
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecificationExamples >> pushUpWithNonExistingSubclassAndSuperclass [
	<gtExample>
	| specification refactoring |
	specification := GtLPushUpMethodSpecification new
			methodNameToPushUp: #initialize;
			methodClassName: #Asdf;
			targetClassName: #AsdfSuperclass.
	self should: [ specification namespaceWithAppliedRefactoring ] raise: Error.
	refactoring := specification asRefactoring.
	self assert: (refactoring isKindOf: GtPushUpMethodRefactoring).
	self assert: refactoring gtDescription equals: 'Push up method Asdf>>initialize'.
	^ specification
]
