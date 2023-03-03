# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create email: 'test@test.com', password: '123qwe', password_confirmation: '123qwe'

client = Client.create name: 'satisfaccion'

survey = Survey.create name: 'empleados', introduction: 'hola empleado', conclusion: 'adios empleado', client: client

survey.questions.create type: "Questions::Checkbox",
                        question_text: "que haces",
                        default_text: nil,
                        placeholder: "",
                        position: 1,
                        answer_options: "comer\r\ndormir\r\ncorrer",
                        validation_rules:
                          {"presence"=>"1",
                          "minimum"=>"",
                          "maximum"=>"",
                          "greater_than_or_equal_to"=>"",
                          "less_than_or_equal_to"=>""},
                        section: 1,

survey.questions.create type: "Questions::Radio",
                        question_text: "como estas",
                        default_text: nil,
                        placeholder: "",
                        position: 1,
                        answer_options: "bien\r\nmas o menos\r\nmal",
                        validation_rules:
                          {"presence"=>"1",
                          "minimum"=>"",
                          "maximum"=>"",
                          "greater_than_or_equal_to"=>"",
                          "less_than_or_equal_to"=>""},
                        section: 1,
