"
Examples for GtLInstructionComposite and related instruction pieces.
"
Class {
	#name : #GtLInstructionCompositeExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLInstructionCompositeExamples >> exampleAddSectionIfAbsent [
	<gtExample>
	| instructions section |
	instructions := GtLInstructionComposite new.
	section := instructions
		sectionNamed: 'Input descriptions'
		ifAbsent: [ :aSection | aSection addString: 'The inputs provided follow the descriptions below' ].
	self assert: section title = 'Input descriptions'.
	self assert: (section body instructionString includesSubstring: 'The inputs provided follow the descriptions below').
	^ instructions
]

{ #category : #examples }
GtLInstructionCompositeExamples >> exampleCreateComposite [
	<gtExample>
	| instructions |
	instructions := GtLInstructionComposite new.
	self assert: instructions isEmpty.
	^ instructions
]

{ #category : #examples }
GtLInstructionCompositeExamples >> exampleHeaderLevelsWithSubsection [
	<gtExample>
	| section composite subSection |
	section := GtLInstructionSection new
		title: 'Header 1';
		body: GtLInstructionComposite new.
	section body addItem: 'Something'.
	composite := GtLInstructionComposite new.
	composite addItem: section.
	subSection := GtLInstructionSection new
		title: 'Header 2';
		body: GtLInstructionComposite new.
	subSection addString: 'Details'.
	section addSection: subSection.
	self assert: section headerLevel = 1.
	self assert: subSection headerLevel = 2.
	^ composite
]
