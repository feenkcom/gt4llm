"
Examples for string and composite diffs.
"
Class {
	#name : #GtLDiffExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Formats'
}

{ #category : #examples }
GtLDiffExamples >> compositeDiff [
	<gtExample>
	| aComposite |
	aComposite := GtLDiff withAll: { self stringDiff. GtLStringDiff from: 'abc' to: 'adc' }.
	self assert: aComposite diffs size equals: 2.
	^ aComposite
]

{ #category : #examples }
GtLDiffExamples >> stringDiff [
	<gtExample>
	| aDiff differences |
	aDiff := GtLStringDiff from: 'hello' to: 'hullo'.
	differences := aDiff differences.
	self assert: differences changes size equals: 1.
	^ aDiff
]
