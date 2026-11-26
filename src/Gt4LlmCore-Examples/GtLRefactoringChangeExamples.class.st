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
	"RB describes every compiled method as added. A change that compiles a method the class already defines is described as modified, consistent with its kind"

	<gtExample>
	<return: #GtLRefactoringChange>
	| rbChange change |
	rbChange := RBAddMethodChange
			compile: 'addMethodRefactoringChange ^ 42'
			in: self class
			classified: 'examples'.
	change := GtLRefactoringChange fromChange: rbChange.
	self assert: change kind equals: 'modified method'.
	self
		assert: change changeDescription
		equals: 'Modify GtLRefactoringChangeExamples>>#addMethodRefactoringChange'.
	self
		assert: rbChange changeString
		equals: 'Add GtLRefactoringChangeExamples>>#addMethodRefactoringChange'.
	^ change
]

{ #category : #examples }
GtLRefactoringChangeExamples >> removeMethodRefactoringChange [
	"A removal carries no source; the description says what is removed, and newSource is left out of the JSON"

	<gtExample>
	<return: #GtLRefactoringChange>
	| rbChange change |
	rbChange := RBRemoveMethodChange
			remove: #addMethodRefactoringChange
			from: self class.
	change := GtLRefactoringChange fromChange: rbChange.
	self assert: change change == rbChange.
	self assert: change kind equals: 'removed method'.
	self
		assert: change target
		equals: 'GtLRefactoringChangeExamples>>#addMethodRefactoringChange'.
	self assert: change hasNewSource not.
	self
		assert: (change llmJsonObjectIncludingSources: true)
		equals: (NeoJSONObject new
				at: 'changeDescription'
					put: 'Remove GtLRefactoringChangeExamples>>#addMethodRefactoringChange';
				at: 'kind' put: 'removed method';
				at: 'target'
					put: 'GtLRefactoringChangeExamples>>#addMethodRefactoringChange';
				yourself).
	^ change
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
