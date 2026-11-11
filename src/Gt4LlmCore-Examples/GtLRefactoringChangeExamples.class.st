Class {
	#name : #GtLRefactoringChangeExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLRefactoringChangeExamples >> addMethodRefactoringChange [
	"A change that adds a method carries the source of the method"

	<gtExample>
	<return: #GtLRefactoringChange>
	| rbChange change |
	rbChange := RBAddMethodChange
			compile: 'previewedMethod ^ 42'
			in: self class
			classified: 'examples'.
	change := GtLRefactoringChange fromChange: rbChange.
	self assert: change change == rbChange.
	self assert: change kind equals: 'added method'.
	self
		assert: change target
		equals: 'GtLRefactoringChangeExamples>>#previewedMethod'.
	self
		assert: change changeDescription
		equals: 'Add GtLRefactoringChangeExamples>>#previewedMethod'.
	self assert: change newSource equals: 'previewedMethod ^ 42'.
	self assert: change hasNewSource.
	^ change
]

{ #category : #examples }
GtLRefactoringChangeExamples >> modifyMethodRefactoringChange [
	"A change that compiles an existing method is a modification"

	<gtExample>
	<return: #GtLRefactoringChange>
	| rbChange change |
	rbChange := RBAddMethodChange
			compile: 'refactoringChange ^ nil'
			in: self class
			classified: 'examples'.
	change := GtLRefactoringChange fromChange: rbChange.
	self assert: change kind equals: 'modified method'.
	self
		assert: change target
		equals: 'GtLRefactoringChangeExamples>>#refactoringChange'.
	self assert: change newSource equals: 'refactoringChange ^ nil'.
	^ change
]

{ #category : #'examples - basic' }
GtLRefactoringChangeExamples >> refactoringChange [
	<gtExample>
	<return: #GtLRefactoringChange>
	| change |
	change := GtLRefactoringChange changeDescription: 'MySuperclass>>foo'
				newSource: 'foo ^ 42'.
	self assert: change changeDescription equals: 'MySuperclass>>foo'.
	self assert: change newSource equals: 'foo ^ 42'.
	^change
]

{ #category : #'examples - views' }
GtLRefactoringChangeExamples >> refactoringChangeMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self refactoringChange llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #examples }
GtLRefactoringChangeExamples >> refactoringChangeSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self refactoringChangeMainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := Dictionary new
			at: #changeDescription put: 'MySuperclass>>foo';
			at: #kind put: nil;
			at: #target put: nil;
			at: #newSource put: 'foo ^ 42';
			yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^ dataBlock
]

{ #category : #examples }
GtLRefactoringChangeExamples >> removeMethodRefactoringChange [
	"A removal carries no source; the description says what is removed"

	<gtExample>
	<return: #GtLRefactoringChange>
	| rbChange change |
	rbChange := RBRemoveMethodChange remove: #refactoringChange from: self class.
	change := GtLRefactoringChange fromChange: rbChange.
	self assert: change change == rbChange.
	self assert: change kind equals: 'removed method'.
	self
		assert: change target
		equals: 'GtLRefactoringChangeExamples>>#refactoringChange'.
	self assert: change newSource isNil.
	self assert: change hasNewSource not.
	^ change
]

{ #category : #examples }
GtLRefactoringChangeExamples >> removeMethodRefactoringChangeSerialization [
	"The RB change is not serialized; newSource is null for a removal"

	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := (self removeMethodRefactoringChange
			llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := Dictionary new
			at: #changeDescription
				put: 'Remove GtLRefactoringChangeExamples>>#refactoringChange';
			at: #kind put: 'removed method';
			at: #target put: 'GtLRefactoringChangeExamples>>#refactoringChange';
			at: #newSource put: nil;
			yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^ dataBlock
]

{ #category : #examples }
GtLRefactoringChangeExamples >> removeSlotRefactoringChange [
	"A slot removal carries no source. Its target is the class that owns the slot"

	<gtExample>
	<return: #GtLRefactoringChange>
	| rbChange change |
	rbChange := RBRemoveInstanceVariableChange
			remove: 'changeDescription'
			from: GtLRefactoringChange.
	change := GtLRefactoringChange fromChange: rbChange.
	self assert: change kind equals: 'removed slot'.
	self assert: change target equals: 'GtLRefactoringChange'.
	self
		assert: change changeDescription
		equals: 'Remove instance variable changeDescription from GtLRefactoringChange'.
	self assert: change newSource isNil.
	^ change
]
