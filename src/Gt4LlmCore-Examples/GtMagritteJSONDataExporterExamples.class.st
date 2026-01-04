Class {
	#name : #GtMagritteJSONDataExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #generation }
GtMagritteJSONDataExporterExamples >> generateJsonForMathReasoningWithSingleType [
	<gtExample>
	| exporter json |
	exporter := GtMagritteJSONDataExporter
			forObject: (GtLDemoMathReasoning new finalAnswer: 'final answer').
	json := exporter exportObjectAsJsonString.
	self assert: json equals: '{
	"steps" : [ ],
	"finalAnswer" : "final answer"
}'.
	^ json
]
