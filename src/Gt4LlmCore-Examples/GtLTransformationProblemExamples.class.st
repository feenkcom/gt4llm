Class {
	#name : #GtLTransformationProblemExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - kinds' }
GtLTransformationProblemExamples >> orderProblemsArePreconditionProblems [
	"The order of the transformations of a call is checked against the image as it is: a transformation on a renamed class must come before the RenameClass"

	<gtExample>
	| transformations problems |
	transformations := GtLCodeTransformations new
			transformations: {GtLRenameClassSpecification new
						className: self class name;
						newClassName: self class name , 'Renamed';
						yourself.
					GtLRemoveMethodSpecification new
						methodClassName: self class name;
						classSide: false;
						methodNameToRemove: 'transformationProblem';
						yourself}.
	problems := transformations gtProblems.
	self assert: problems size equals: 1.
	self assert: problems first class equals: GtLTransformationPreconditionProblem.
	^ problems
]

{ #category : #'examples - kinds' }
GtLTransformationProblemExamples >> parameterProblemsComeFirst [
	"A specification checks its parameters first, from the arguments alone. It checks what its refactoring expects of the code only once the parameters are valid"

	<gtExample>
	| specification problems |
	specification := GtLRenameClassSpecification new
			className: 'GtLNoSuchClassForProblems';
			newClassName: 'not a class name';
			yourself.
	problems := specification gtProblems.
	self assert: problems size equals: 1.
	self assert: problems first class equals: GtLTransformationParameterProblem.
	specification newClassName: 'GtLRenamedClassForProblems'.
	problems := specification gtProblems.
	self assert: problems size equals: 1.
	self assert: problems first class equals: GtLTransformationPreconditionProblem.
	self
		assert: problems first description
		equals: 'Class not found: GtLNoSuchClassForProblems'.
	^ problems
]

{ #category : #'examples - kinds' }
GtLTransformationProblemExamples >> problemKindsOfTransformations [
	"A missing name, a class side named as a class and a source that does not parse are problems with the parameters. An unknown class or method is a problem with the code"

	<gtExample>
	| problemOf problems |
	problemOf := [ :aSpecification | 
		| someProblems |
		someProblems := aSpecification gtProblems.
		self assert: someProblems size equals: 1.
		someProblems first ].
	problems := {problemOf
				value: (GtLRemoveMethodSpecification new
						methodClassName: self class name;
						classSide: false;
						methodNameToRemove: '';
						yourself).
			problemOf
				value: (GtLPushUpInstanceVariableSpecification new
						variableClassName: 'Object';
						yourself).
			problemOf
				value: (GtLRemoveClassSpecification new
						classNameToRemove: 'Object class';
						yourself).
			problemOf
				value: (GtLRemoveMethodSpecification new
						methodClassName: 'Object class';
						classSide: false;
						methodNameToRemove: 'new';
						yourself).
			problemOf
				value: (GtLAddMethodSpecification new
						methodClassName: self class name;
						classSide: false;
						protocol: 'examples';
						sourceCode: 'brokenMethod ^ (';
						yourself)}.
	self
		assert: (problems collect: [ :each | each class ]) asSet asArray
		equals: {GtLTransformationParameterProblem}.
	self
		assert: ((problems first: 4) collect: [ :each | each description ]) asArray
		equals: #('Missing method name' 'Missing variable name' 'Object class is the class side of Object. Remove Object instead.' 'Object class is the class side of Object: name Object and set classSide to true').
	problems := {problemOf
				value: (GtLRemoveMethodSpecification new
						methodClassName: self class name;
						classSide: false;
						methodNameToRemove: 'noSuchMethodForProblems';
						yourself).
			problemOf
				value: (GtLAddMethodSpecification new
						methodClassName: 'GtLNoSuchClassForProblems';
						classSide: false;
						protocol: 'examples';
						sourceCode: 'addedMethod ^ 42';
						yourself)}.
	self
		assert: (problems collect: [ :each | each class ]) asSet asArray
		equals: {GtLTransformationPreconditionProblem}.
	self
		assert: problems last description
		equals: 'Class not found: GtLNoSuchClassForProblems'.
	^ problems
]

{ #category : #'examples - basic' }
GtLTransformationProblemExamples >> transformationProblem [
	<gtExample>
	<return: #GtLTransformationProblem>
	| problem |
	problem := GtLTransformationPreconditionProblem
			description: 'Class not found: ClassThatDoesNotExist'.
	self
		assert: problem description
		equals: 'Class not found: ClassThatDoesNotExist'.
	^ problem
]

{ #category : #'examples - views' }
GtLTransformationProblemExamples >> transformationProblemMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self transformationProblem
				llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #'examples - serialization' }
GtLTransformationProblemExamples >> transformationProblemSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self transformationProblemMainDataView
				serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := (Dictionary new)
				at: 'description' put: 'Class not found: ClassThatDoesNotExist';
				yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^dataBlock
]
