Class {
	#name : #GtMagritteJSONSchemaExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #assertions }
GtMagritteJSONSchemaExporterExamples >> assertSchema: aJsonSchema equals: aSchemString [
	self 
		assert: (NeoJSONWriter toStringPretty: aJsonSchema json)
		equals: aSchemString
]

{ #category : #expected }
GtMagritteJSONSchemaExporterExamples >> expectedSchemaStringForMathReasoningWithMultipleTypes [
	^ '{
	"type" : "object",
	"properties" : {
		"steps" : {
			"type" : "array",
			"items" : {
				"anyOf" : [
					{
						"type" : "object",
						"properties" : {
							"content" : {
								"type" : "string",
								"description" : "An explanation of this step"
							}
						},
						"required" : [
							"content"
						],
						"additionalProperties" : false
					},
					{
						"type" : "object",
						"properties" : {
							"output" : {
								"type" : "string"
							}
						},
						"required" : [
							"output"
						],
						"additionalProperties" : false
					}
				]
			}
		},
		"finalAnswer" : {
			"type" : "string"
		}
	},
	"required" : [
		"steps",
		"finalAnswer"
	],
	"additionalProperties" : false
}'
]

{ #category : #expected }
GtMagritteJSONSchemaExporterExamples >> expectedSchemaStringForMathReasoningWithSingleType [
	^ '{
	"type" : "object",
	"properties" : {
		"steps" : {
			"type" : "array",
			"items" : {
				"type" : "object",
				"properties" : {
					"explanation" : {
						"type" : "string",
						"description" : "An explanation of this step"
					},
					"output" : {
						"type" : "string"
					}
				},
				"required" : [
					"explanation",
					"output"
				],
				"additionalProperties" : false
			}
		},
		"finalAnswer" : {
			"type" : "string"
		}
	},
	"required" : [
		"steps",
		"finalAnswer"
	],
	"additionalProperties" : false
}'
]

{ #category : #generation }
GtMagritteJSONSchemaExporterExamples >> generateSchemaForMathReasoningWithMultipleTypes [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter 
		forModelClass: GtLDemoMathReasoningWithDifferentSteps.
	^ exporter exportSchema
]

{ #category : #generation }
GtMagritteJSONSchemaExporterExamples >> generateSchemaForMathReasoningWithSingleType [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter forModelClass: GtLDemoMathReasoning.
	^ exporter exportSchema
]

{ #category : #examples }
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithMultipleTypes [
	<gtExample>
	self  
		assertSchema: self generateSchemaForMathReasoningWithMultipleTypes
		equals: self expectedSchemaStringForMathReasoningWithMultipleTypes
]

{ #category : #examples }
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithSingleType [
	<gtExample>
	self 
		assertSchema: self generateSchemaForMathReasoningWithSingleType
		equals: self expectedSchemaStringForMathReasoningWithSingleType
]
