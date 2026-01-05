Class {
	#name : #GtMagritteJSONDataExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #generation }
GtMagritteJSONDataExporterExamples >> generateJsonForMathReasoningWithDelegatedSteps [
	<gtExample>
	| exporter json |
	exporter := GtMagritteJSONDataExporter
			forObject: (GtMagritteJSONSchemaDataReaderExamples new expectedMathReasoningDelegatedTypesTypeStep).
	json := exporter exportObjectAsJsonString.
	self assert: json equals: '{
	"steps" : [
		{
			"step" : {
				"content" : "Start by isolating the term with x: subtract 7 from both sides, giving 8x = -30."
			}
		},
		{
			"step" : {
				"content" : "Next, divide both sides by 8 to solve for x. This yields x = -30/8."
			}
		},
		{
			"step" : {
				"content" : "Simplify the fraction by dividing numerator and denominator by 2: x = -15/4."
			}
		},
		{
			"step" : {
				"output" : "x = -15/4"
			}
		}
	],
	"finalAnswer" : "The solution to the equation 8x + 7 = -23 is x = -15/4."
}'.
	^ json
]

{ #category : #generation }
GtMagritteJSONDataExporterExamples >> generateJsonForMathReasoningWithOnlyFinalAnswer [
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

{ #category : #generation }
GtMagritteJSONDataExporterExamples >> generateJsonForMathReasoningWithStepsAndFinalAnswer [
	<gtExample>
	| exporter json |
	exporter := GtMagritteJSONDataExporter
			forObject: (GtMagritteJSONSchemaDataReaderExamples new expectedMathReasoningWithSingleTypeStep).
	json := exporter exportObjectAsJsonString.
	self assert: json equals: '{
	"steps" : [
		{
			"output" : "8x + 7 = -23",
			"explanation" : "Start with the equation 8x + 7 = -23."
		},
		{
			"output" : "8x = -23 - 7",
			"explanation" : "Subtract 7 from both sides to isolate the term with the variable."
		},
		{
			"output" : "8x = -30",
			"explanation" : "Simplify the right side of the equation."
		},
		{
			"output" : "x = -30 / 8",
			"explanation" : "Divide both sides by 8 to solve for x."
		},
		{
			"output" : "x = -15 / 4",
			"explanation" : "Simplify the fraction."
		}
	],
	"finalAnswer" : "x = -15 / 4"
}'.
	^ json
]
