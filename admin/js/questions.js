{
  "type": "question",
  "text": "Тип дома",
  "answers": [
    {
      "text": "Частный дом",
      "type": "button",
      "next_question_id": {
        "type": "question",
        "text": "Есть у тебя счетчик?",
        "answers": [
          {
            "text": "Да",
            "type": "button",
            "next_question_id": {
              "type": "input",
              "text": "Введи данные счетчика!",
              "answers": [
                {
                  "text": "Количество электрической энергии",
                  "type": "input",
                  "param_name": "watts"
                },
                {
                  "type": "button",
                  "text": "Далее",
                  "next_question_id": {
                    "type": "input",
                    "text": "Какая сумма у тебя в квитанции?",
                    "answers": [
                      {
                        "text": "Сумма",
                        "type": "input",
                        "param_name": "summ"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "method": {
                          "url": "formula1",
                          "params": [
                            {
                              "param_name": "watts"
                            },
                            {
                              "param_name": "summ"
                            }
                          ]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          {
            "text": "Нет",
            "type": "button",
            "next_question_id": {
              "type": "question",
              "text": "Есть технические условия для установки счетчика?",
              "answers": [
                {
                  "text": "Да",
                  "type": "button",
                  "next_question_id": {
                    "type": "input",
                    "text": "Введи норматив!",
                    "answers": [
                      {
                        "text": "",
                        "type": "input",
                        "param_name": "n_watts"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "next_question_id": {
                          "type": "input",
                          "text": "А сколько у тебя в доме человек живет?",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "dwellers"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "Какая сумма у тебя в квитанции?",
                                "answers": [
                                  {
                                    "text": "Сумма",
                                    "type": "input",
                                    "param_name": "summ"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "question",
                                      "text": "Совет - ставить счетчик, экономия 30%, а иначе действует повышающий коэффициент - в полтора раза больше платишь!",
                                      "answers": [
                                        {
                                          "text": "Далее",
                                          "type": "button",
                                          "method": {
                                            "url": "formula4_2",
                                            "params": [
                                              {
                                                "param_name": "n_watts"
                                              },
                                              {
                                                "param_name": "dwellers"
                                              },
                                              {
                                                "param_name": "summ"
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                },
                {
                  "text": "Нет",
                  "type": "button",
                  "next_question_id": {
                    "type": "question",
                    "text": "Посмотри, есть ли у тебя акт о том, что нет технических условий!",
                    "answers": [
                      {
                        "text": "Да",
                        "type": "button",
                        "next_question_id": {
                          "type": "input",
                          "text": "Введи норматив!",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "n_watts"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "А сколько у тебя в доме человек живет?",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "dwellers"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Какая сумма у тебя в квитанции?",
                                      "answers": [
                                        {
                                          "text": "Сумма",
                                          "type": "input",
                                          "param_name": "summ"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "method": {
                                            "url": "formula4_1",
                                            "params": [
                                              {
                                                "param_name": "n_watts"
                                              },
                                              {
                                                "param_name": "dwellers"
                                              },
                                              {
                                                "param_name": "summ"
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      },
                      {
                        "text": "Нет",
                        "type": "button",
                        "next_question_id": {
                          "type": "question",
                          "text": "Зто всё равно, что есть условия - в полтора раза больше платишь!",
                          "answers": [
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "Введи норматив!",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "n_watts"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "А сколько у тебя в доме человек живет?",
                                      "answers": [
                                        {
                                          "text": "",
                                          "type": "input",
                                          "param_name": "dwellers"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "Какая сумма у тебя в квитанции?",
                                            "answers": [
                                              {
                                                "text": "Сумма",
                                                "type": "input",
                                                "param_name": "summ"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "method": {
                                                  "url": "formula4_2",
                                                  "params": [
                                                    {
                                                      "param_name": "n_watts"
                                                    },
                                                    {
                                                      "param_name": "dwellers"
                                                    },
                                                    {
                                                      "param_name": "summ"
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ],
                          "hint": "Составь акт!"
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    },
    {
      "text": "Многоквартирный дом",
      "type": "button",
      "next_question_id": {
        "type": "question",
        "text": "Что считаем?",
        "answers": [
          {
            "text": "Индивидуальный расход",
            "type": "button",
            "next_question_id": {
              "type": "question",
              "text": "Есть у тебя счетчик?",
              "answers": [
                {
                  "text": "Да",
                  "type": "button",
                  "next_question_id": {
                    "type": "input",
                    "text": "Введи данные счетчика!",
                    "answers": [
                      {
                        "text": "Количество электрической энергии",
                        "type": "input",
                        "param_name": "watts"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "next_question_id": {
                          "type": "input",
                          "text": "Какая сумма у тебя в квитанции?",
                          "answers": [
                            {
                              "text": "Сумма",
                              "type": "input",
                              "param_name": "summ"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "method": {
                                "url": "formula1",
                                "params": [
                                  {
                                    "param_name": "watts"
                                  },
                                  {
                                    "param_name": "summ"
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                },
                {
                  "text": "Нет",
                  "type": "button",
                  "next_question_id": {
                    "type": "question",
                    "text": "Есть технические условия для установки счетчика?",
                    "answers": [
                      {
                        "text": "Да",
                        "type": "button",
                        "next_question_id": {
                          "type": "input",
                          "text": "Введи норматив",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "n_watts"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "А сколько у тебя в доме человек живет?",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "dwellers"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Какая сумма у тебя в квитанции?",
                                      "answers": [
                                        {
                                          "text": "Сумма",
                                          "type": "input",
                                          "param_name": "summ"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "method": {
                                            "url": "formula4_2",
                                            "params": [
                                              {
                                                "param_name": "n_watts"
                                              },
                                              {
                                                "param_name": "dwellers"
                                              },
                                              {
                                                "param_name": "summ"
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      },
                      {
                        "text": "Нет",
                        "type": "button",
                        "next_question_id": {
                          "type": "question",
                          "text": "Посмотри, есть ли у тебя акт о том, что нет технических условий!",
                          "answers": [
                            {
                              "text": "Есть",
                              "type": "button",
                              "next_question_id": {
                                "type": "input",
                                "text": "Введи норматив",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "n_watts"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "А сколько у тебя в доме человек живет?",
                                      "answers": [
                                        {
                                          "text": "",
                                          "type": "input",
                                          "param_name": "dwellers"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "Какая сумма у тебя в квитанции?",
                                            "answers": [
                                              {
                                                "text": "Сумма",
                                                "type": "input",
                                                "param_name": "summ"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "method": {
                                                  "url": "formula4_1",
                                                  "params": [
                                                    {
                                                      "param_name": "n_watts"
                                                    },
                                                    {
                                                      "param_name": "dwellers"
                                                    },
                                                    {
                                                      "param_name": "summ"
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            },
                            {
                              "text": "Нет",
                              "type": "button",
                              "next_question_id": {
                                "type": "question",
                                "text": "Зто всё равно, что есть условия - в полтора раза больше платишь!",
                                "answers": [
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Введи норматив!",
                                      "answers": [
                                        {
                                          "text": "",
                                          "type": "input",
                                          "param_name": "n_watts"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "А сколько у тебя в доме человек живет?",
                                            "answers": [
                                              {
                                                "text": "",
                                                "type": "input",
                                                "param_name": "dwellers"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "next_question_id": {
                                                  "type": "input",
                                                  "text": "Какая сумма у тебя в квитанции?",
                                                  "answers": [
                                                    {
                                                      "text": "Сумма",
                                                      "type": "input",
                                                      "param_name": "summ"
                                                    },
                                                    {
                                                      "type": "button",
                                                      "text": "Далее",
                                                      "method": {
                                                        "url": "formula4_2",
                                                        "params": [
                                                          {
                                                            "param_name": "n_watts"
                                                          },
                                                          {
                                                            "param_name": "dwellers"
                                                          },
                                                          {
                                                            "param_name": "summ"
                                                          }
                                                        ]
                                                      }
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ],
                                "hint": "Составь акт!"
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          {
            "text": "Общедомовые нужды",
            "type": "button",
            "next_question_id": {
              "type": "question",
              "text": "А общедомовой счетчик есть в твоем доме?",
              "answers": [
                {
                  "text": "Да",
                  "type": "button",
                  "next_question_id": {
                    "type": "input",
                    "text": "Введи данные счетчика!",
                    "answers": [
                      {
                        "text": "Количество электрической энергии",
                        "type": "input",
                        "param_name": "watts"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "next_question_id": {
                          "type": "input",
                          "text": "Надо тебе узнать количество электричества  (объем коммунального ресурса поступившего в дом)!",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "v_d"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "Количество электричества, которое пришлось на нежилые помещения.",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "v_u"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Количество электричества, которое пришлось на жилые помещения, в которых нет индивидуального счётчика",
                                      "answers": [
                                        {
                                          "text": "",
                                          "type": "input",
                                          "param_name": "v_v"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "Количество электричества, которое пришлось на жилые помещения, в которых есть индивидуальный счётчик.",
                                            "answers": [
                                              {
                                                "text": "",
                                                "type": "input",
                                                "param_name": "v_w"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "next_question_id": {
                                                  "type": "input",
                                                  "text": "Общую площадь всех жилых помещений в доме!",
                                                  "answers": [
                                                    {
                                                      "text": "",
                                                      "type": "input",
                                                      "param_name": "s_v"
                                                    },
                                                    {
                                                      "type": "button",
                                                      "text": "Далее",
                                                      "next_question_id": {
                                                        "type": "input",
                                                        "text": "Общую площадь всех нежилых помещений в доме!",
                                                        "answers": [
                                                          {
                                                            "text": "",
                                                            "type": "input",
                                                            "param_name": "s_u"
                                                          },
                                                          {
                                                            "type": "button",
                                                            "text": "Далее",
                                                            "next_question_id": {
                                                              "type": "input",
                                                              "text": "Площадь твоей квартиры!",
                                                              "answers": [
                                                                {
                                                                  "text": "",
                                                                  "type": "input",
                                                                  "param_name": "s_i"
                                                                },
                                                                {
                                                                  "type": "button",
                                                                  "text": "Далее",
                                                                  "next_question_id": {
                                                                    "type": "input",
                                                                    "text": "Какая сумма у тебя в квитанции?",
                                                                    "answers": [
                                                                      {
                                                                        "text": "Сумма",
                                                                        "type": "input",
                                                                        "param_name": "summ"
                                                                      },
                                                                      {
                                                                        "type": "button",
                                                                        "text": "Далее",
                                                                        "method": {
                                                                          "url": "formula12",
                                                                          "params": [
                                                                            {
                                                                              "param_name": "watts"
                                                                            },
                                                                            {
                                                                              "param_name": "v_d"
                                                                            },
                                                                            {
                                                                              "param_name": "v_u"
                                                                            },
                                                                            {
                                                                              "param_name": "v_v"
                                                                            },
                                                                            {
                                                                              "param_name": "v_w"
                                                                            },
                                                                            {
                                                                              "param_name": "s_i"
                                                                            },
                                                                            {
                                                                              "param_name": "s_v"
                                                                            },
                                                                            {
                                                                              "param_name": "s_u"
                                                                            },
                                                                            {
                                                                              "param_name": "summ"
                                                                            }
                                                                          ]
                                                                        }
                                                                      }
                                                                    ]
                                                                  }
                                                                }
                                                              ]
                                                            }
                                                          }
                                                        ]
                                                      }
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                },
                {
                  "text": "Нет",
                  "type": "button",
                  "next_question_id": {
                    "type": "input",
                    "text": "Общую площадь всех жилых помещений в доме!",
                    "answers": [
                      {
                        "text": "",
                        "type": "input",
                        "param_name": "s_v"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "next_question_id": {
                          "type": "input",
                          "text": "Общую площадь всех нежилых помещений в доме!",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "s_u"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "Общую площадь помещений, входящих в состав общего имущества!",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "s_oi"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Площадь твоей квартиры!",
                                      "answers": [
                                        {
                                          "text": "Сумма",
                                          "type": "input",
                                          "param_name": "s_i"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "Какая сумма у тебя в квитанции?",
                                            "answers": [
                                              {
                                                "text": "Сумма",
                                                "type": "input",
                                                "param_name": "summ"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "next_question_id": {
                                                  "type": "input",
                                                  "text": "И введи норматив!",
                                                  "answers": [
                                                    {
                                                      "text": "",
                                                      "type": "input",
                                                      "param_name": "norm"
                                                    },
                                                    {
                                                      "type": "button",
                                                      "text": "Далее",
                                                      "method": {
                                                        "url": "formula15",
                                                        "params": [
                                                          {
                                                            "param_name": "s_u"
                                                          },
                                                          {
                                                            "param_name": "s_v"
                                                          },
                                                          {
                                                            "param_name": "s_oi"
                                                          },
                                                          {
                                                            "param_name": "s_i"
                                                          },
                                                          {
                                                            "param_name": "norm"
                                                          },
                                                          {
                                                            "param_name": "summ"
                                                          }
                                                        ]
                                                      }
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    },
    {
      "text": "Коммунальная квартира",
      "type": "button",
      "next_question_id": {
        "type": "question",
        "text": "Что считаем?",
        "answers": [
          {
            "text": "Индивидуальный расход",
            "type": "button",
            "next_question_id": {
              "type": "question",
              "text": "Счетчик у тебя есть?",
              "answers": [
                {
                  "text": "Да",
                  "type": "button",
                  "param_name": "meter",
                  "param_value": "on"
                },
                {
                  "text": "Нет",
                  "type": "button",
                  "param_name": "meter",
                  "param_value": "off"
                }
              ],
              "next_question_id": {
                "type": "question",
                "text": "А у всех соседей есть счетчик?",
                "answers": [
                  {
                    "text": "Да",
                    "type": "button",
                    "param_name": "meter_others",
                    "param_value": "on"
                  },
                  {
                    "text": "Нет",
                    "type": "button",
                    "param_name": "meter_others",
                    "param_value": "off"
                  }
                ],
                "next_question_id": {
                  "type": "question",
                  "text": "А общедомовой счетчик есть в доме?",
                  "answers": [
                    {
                      "text": "Да",
                      "type": "button",
                      "param_name": "meter_all",
                      "param_value": "on",
                      "next_question_id": "conditions",
                      "conditions": {
                        "params": [
                          {
                            "param_name": "meter"
                          },
                          {
                            "param_name": "meter_others"
                          }
                        ],
                        "next_question_ids": {
                          "onon": {
                            "type": "input",
                            "text": "Количество комнат в коммунальной квартире",
                            "answers": [
                              {
                                "text": "",
                                "type": "input",
                                "param_name": "rooms"
                              },
                              {
                                "type": "button",
                                "text": "Далее",
                                "next_question_id": {
                                  "type": "input",
                                  "text": "Количество граждан, постоянно и временно проживающих в коммунальной квартире",
                                  "answers": [
                                    {
                                      "text": "",
                                      "type": "input",
                                      "param_name": "n"
                                    },
                                    {
                                      "type": "button",
                                      "text": "Далее",
                                      "next_question_id": {
                                        "type": "input",
                                        "text": "Количество граждан, постоянно и временно проживающих в комнате",
                                        "answers": [
                                          {
                                            "text": "",
                                            "type": "input",
                                            "param_name": "n_i"
                                          },
                                          {
                                            "type": "button",
                                            "text": "Далее",
                                            "next_question_id": {
                                              "type": "input",
                                              "text": "Количество электрической энергии, определенный по показаниям общего (квартирного) прибора учета",
                                              "answers": [
                                                {
                                                  "text": "",
                                                  "type": "input",
                                                  "param_name": "v"
                                                },
                                                {
                                                  "type": "button",
                                                  "text": "Далее",
                                                  "next_question_id": {
                                                    "type": "input",
                                                    "text": "Количество электрической энергии, определенный по показаниям комнатного прибора учета",
                                                    "answers": [
                                                      {
                                                        "text": "",
                                                        "type": "input",
                                                        "param_name": "v_i"
                                                      },
                                                      {
                                                        "type": "button",
                                                        "text": "Далее",
                                                        "next_question_id": {
                                                          "type": "input",
                                                          "text": "Количество электрической энергии, в комнатах соседей",
                                                          "answers": [
                                                            {
                                                              "text": "",
                                                              "type": "input",
                                                              "param_name": "v_o"
                                                            },
                                                            {
                                                              "type": "button",
                                                              "text": "Далее",
                                                              "next_question_id": {
                                                                "type": "input",
                                                                "text": "Какая сумма у тебя в квитанции?",
                                                                "answers": [
                                                                  {
                                                                    "text": "",
                                                                    "type": "input",
                                                                    "param_name": "summ"
                                                                  },
                                                                  {
                                                                    "type": "button",
                                                                    "text": "Далее",
                                                                    "method": {
                                                                      "url": "formula9",
                                                                      "params": [
                                                                        {
                                                                          "param_name": "rooms"
                                                                        },
                                                                        {
                                                                          "param_name": "n"
                                                                        },
                                                                        {
                                                                          "param_name": "n_i"
                                                                        },
                                                                        {
                                                                          "param_name": "v"
                                                                        },
                                                                        {
                                                                          "param_name": "v_i"
                                                                        },
                                                                        {
                                                                          "param_name": "v_o"
                                                                        },
                                                                        {
                                                                          "param_name": "summ"
                                                                        }
                                                                      ]
                                                                    }
                                                                  }
                                                                ]
                                                              }
                                                            }
                                                          ]
                                                        }
                                                      }
                                                    ]
                                                  }
                                                }
                                              ]
                                            }
                                          }
                                        ]
                                      }
                                    }
                                  ]
                                }
                              }
                            ]
                          },
                          "default": {
                            "type": "input",
                            "text": "Количество граждан, постоянно и временно проживающих в коммунальной квартире",
                            "answers": [
                              {
                                "text": "",
                                "type": "input",
                                "param_name": "n"
                              },
                              {
                                "type": "button",
                                "text": "Далее",
                                "next_question_id": {
                                  "type": "input",
                                  "text": "Количество граждан, постоянно и временно проживающих в комнате",
                                  "answers": [
                                    {
                                      "text": "",
                                      "type": "input",
                                      "param_name": "n_i"
                                    },
                                    {
                                      "type": "button",
                                      "text": "Далее",
                                      "next_question_id": {
                                        "type": "input",
                                        "text": "Количество электрической энергии, определенный по показаниям общего (квартирного) прибора учета",
                                        "answers": [
                                          {
                                            "text": "",
                                            "type": "input",
                                            "param_name": "v"
                                          },
                                          {
                                            "type": "button",
                                            "text": "Далее",
                                            "next_question_id": {
                                              "type": "input",
                                              "text": "Какая сумма у тебя в квитанции?",
                                              "answers": [
                                                {
                                                  "text": "",
                                                  "type": "input",
                                                  "param_name": "summ"
                                                },
                                                {
                                                  "type": "button",
                                                  "text": "Далее",
                                                  "method": {
                                                    "url": "formula7",
                                                    "params": [
                                                      {
                                                        "param_name": "n"
                                                      },
                                                      {
                                                        "param_name": "n_i"
                                                      },
                                                      {
                                                        "param_name": "v"
                                                      },
                                                      {
                                                        "param_name": "summ"
                                                      }
                                                    ]
                                                  }
                                                }
                                              ]
                                            }
                                          }
                                        ]
                                      }
                                    }
                                  ]
                                }
                              }
                            ]
                          }
                        }
                      }
                    },
                    {
                      "text": "Нет",
                      "type": "button",
                      "param_name": "meter_all",
                      "param_value": "off",
                      "next_question_id": {
                        "type": "question",
                        "text": "А технические условия для установки общедомового счетчика есть?",
                        "answers": [
                          {
                            "text": "Да",
                            "type": "button",
                            "next_question_id": {
                              "type": "question",
                              "text": "Совет - настоять на собрании жильцов, чтобы ставили счетчик, экономия 30%, а иначе действует повышающий коэффициент - в полтора раза больше платите!",
                              "answers": [
                                {
                                  "text": "Далее",
                                  "type": "button",
                                  "next_question_id": {
                                    "type": "input",
                                    "text": "А сколько у тебя в комнате человек живет?",
                                    "answers": [
                                      {
                                        "text": "",
                                        "type": "input",
                                        "param_name": "n_i"
                                      },
                                      {
                                        "type": "button",
                                        "text": "Далее",
                                        "next_question_id": {
                                          "type": "input",
                                          "text": "А сколько человек всего в квартире?",
                                          "answers": [
                                            {
                                              "text": "",
                                              "type": "input",
                                              "param_name": "n"
                                            },
                                            {
                                              "type": "button",
                                              "text": "Далее",
                                              "next_question_id": {
                                                "type": "input",
                                                "text": "Количество потреблённой электрической энергии",
                                                "answers": [
                                                  {
                                                    "text": "",
                                                    "type": "input",
                                                    "param_name": "v"
                                                  },
                                                  {
                                                    "type": "button",
                                                    "text": "Далее",
                                                    "next_question_id": {
                                                      "type": "input",
                                                      "text": "Какая сумма у тебя в квитанции?",
                                                      "answers": [
                                                        {
                                                          "text": "",
                                                          "type": "input",
                                                          "param_name": "summ"
                                                        },
                                                        {
                                                          "type": "button",
                                                          "text": "Далее",
                                                          "method": {
                                                            "url": "formula7_1",
                                                            "params": [
                                                              {
                                                                "param_name": "n"
                                                              },
                                                              {
                                                                "param_name": "n_i"
                                                              },
                                                              {
                                                                "param_name": "v"
                                                              },
                                                              {
                                                                "param_name": "summ"
                                                              }
                                                            ]
                                                          }
                                                        }
                                                      ]
                                                    }
                                                  }
                                                ]
                                              }
                                            }
                                          ]
                                        }
                                      }
                                    ]
                                  }
                                }
                              ]
                            }
                          },
                          {
                            "text": "Нет",
                            "type": "button",
                            "next_question_id": {
                              "type": "question",
                              "text": "Узнай у председателя, есть ли акт о том, что нет технических условий!",
                              "answers": [
                                {
                                  "text": "Есть",
                                  "type": "button",
                                  "next_question_id": {
                                    "type": "input",
                                    "text": "А сколько у тебя в комнате человек живет?",
                                    "answers": [
                                      {
                                        "text": "",
                                        "type": "input",
                                        "param_name": "n_i"
                                      },
                                      {
                                        "type": "button",
                                        "text": "Далее",
                                        "next_question_id": {
                                          "type": "input",
                                          "text": "А сколько человек всего в квартире?",
                                          "answers": [
                                            {
                                              "text": "",
                                              "type": "input",
                                              "param_name": "n"
                                            },
                                            {
                                              "type": "button",
                                              "text": "Далее",
                                              "next_question_id": {
                                                "type": "input",
                                                "text": "Количество потреблённой электрической энергии",
                                                "answers": [
                                                  {
                                                    "text": "",
                                                    "type": "input",
                                                    "param_name": "v"
                                                  },
                                                  {
                                                    "type": "button",
                                                    "text": "Далее",
                                                    "next_question_id": {
                                                      "type": "input",
                                                      "text": "Какая сумма у тебя в квитанции?",
                                                      "answers": [
                                                        {
                                                          "text": "",
                                                          "type": "input",
                                                          "param_name": "summ"
                                                        },
                                                        {
                                                          "type": "button",
                                                          "text": "Далее",
                                                          "method": {
                                                            "url": "formula7_1",
                                                            "params": [
                                                              {
                                                                "param_name": "n"
                                                              },
                                                              {
                                                                "param_name": "n_i"
                                                              },
                                                              {
                                                                "param_name": "v"
                                                              },
                                                              {
                                                                "param_name": "summ"
                                                              }
                                                            ]
                                                          }
                                                        }
                                                      ]
                                                    }
                                                  }
                                                ]
                                              }
                                            }
                                          ]
                                        }
                                      }
                                    ]
                                  }
                                },
                                {
                                  "text": "Нет",
                                  "type": "button",
                                  "next_question_id": {
                                    "type": "question",
                                    "text": "Это всё равно, что есть условия - в полтора раза больше платите!",
                                    "answers": [
                                      {
                                        "type": "button",
                                        "text": "Далее",
                                        "next_question_id": {
                                          "type": "input",
                                          "text": "А сколько у тебя в комнате человек живет?",
                                          "answers": [
                                            {
                                              "text": "",
                                              "type": "input",
                                              "param_name": "n_i"
                                            },
                                            {
                                              "type": "button",
                                              "text": "Далее",
                                              "next_question_id": {
                                                "type": "input",
                                                "text": "А сколько человек всего в квартире?",
                                                "answers": [
                                                  {
                                                    "text": "",
                                                    "type": "input",
                                                    "param_name": "n"
                                                  },
                                                  {
                                                    "type": "button",
                                                    "text": "Далее",
                                                    "next_question_id": {
                                                      "type": "input",
                                                      "text": "Количество потреблённой электрической энергии",
                                                      "answers": [
                                                        {
                                                          "text": "",
                                                          "type": "input",
                                                          "param_name": "v"
                                                        },
                                                        {
                                                          "type": "button",
                                                          "text": "Далее",
                                                          "next_question_id": {
                                                            "type": "input",
                                                            "text": "Какая сумма у тебя в квитанции?",
                                                            "answers": [
                                                              {
                                                                "text": "",
                                                                "type": "input",
                                                                "param_name": "summ"
                                                              },
                                                              {
                                                                "type": "button",
                                                                "text": "Далее",
                                                                "method": {
                                                                  "url": "formula7_1",
                                                                  "params": [
                                                                    {
                                                                      "param_name": "n"
                                                                    },
                                                                    {
                                                                      "param_name": "n_i"
                                                                    },
                                                                    {
                                                                      "param_name": "v"
                                                                    },
                                                                    {
                                                                      "param_name": "summ"
                                                                    }
                                                                  ]
                                                                }
                                                              }
                                                            ]
                                                          }
                                                        }
                                                      ]
                                                    }
                                                  }
                                                ]
                                              }
                                            }
                                          ]
                                        }
                                      }
                                    ]
                                  }
                                }
                              ]
                            }
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            }
          },
          {
            "text": "Общедомовые нужды",
            "type": "button",
            "next_question_id": {
              "type": "question",
              "text": "Общедомовой счетчик у вас в доме есть?",
              "answers": [
                {
                  "text": "Да",
                  "type": "button",
                  "next_question_id": {
                    "type": "input",
                    "text": "Введи данные счетчика!",
                    "answers": [
                      {
                        "text": "Количество электрической энергии",
                        "type": "input",
                        "param_name": "watts"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "next_question_id": {
                          "type": "input",
                          "text": "Надо тебе узнать количество электричества  (объем коммунального ресурса поступившего в дом)!",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "v_d"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "Количество электричества, которое пришлось на нежилые помещения.",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "v_u"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Количество электричества, которое пришлось на жилые помещения, в которых нет индивидуального счётчика",
                                      "answers": [
                                        {
                                          "text": "",
                                          "type": "input",
                                          "param_name": "v_v"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "Количество электричества, которое пришлось на жилые помещения, в которых есть индивидуальный счётчик.",
                                            "answers": [
                                              {
                                                "text": "",
                                                "type": "input",
                                                "param_name": "v_w"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "next_question_id": {
                                                  "type": "input",
                                                  "text": "Общую площадь всех жилых помещений в доме!",
                                                  "answers": [
                                                    {
                                                      "text": "",
                                                      "type": "input",
                                                      "param_name": "s_v"
                                                    },
                                                    {
                                                      "type": "button",
                                                      "text": "Далее",
                                                      "next_question_id": {
                                                        "type": "input",
                                                        "text": "Общую площадь всех нежилых помещений в доме!",
                                                        "answers": [
                                                          {
                                                            "text": "",
                                                            "type": "input",
                                                            "param_name": "s_u"
                                                          },
                                                          {
                                                            "type": "button",
                                                            "text": "Далее",
                                                            "next_question_id": {
                                                              "type": "input",
                                                              "text": "Площадь твоей комнаты!",
                                                              "answers": [
                                                                {
                                                                  "text": "",
                                                                  "type": "input",
                                                                  "param_name": "s_i"
                                                                },
                                                                {
                                                                  "type": "button",
                                                                  "text": "Далее",
                                                                  "next_question_id": {
                                                                    "type": "input",
                                                                    "text": "Какая сумма у тебя в квитанции?",
                                                                    "answers": [
                                                                      {
                                                                        "text": "Сумма",
                                                                        "type": "input",
                                                                        "param_name": "summ"
                                                                      },
                                                                      {
                                                                        "type": "button",
                                                                        "text": "Далее",
                                                                        "method": {
                                                                          "url": "formula12",
                                                                          "params": [
                                                                            {
                                                                              "param_name": "watts"
                                                                            },
                                                                            {
                                                                              "param_name": "v_d"
                                                                            },
                                                                            {
                                                                              "param_name": "v_u"
                                                                            },
                                                                            {
                                                                              "param_name": "v_v"
                                                                            },
                                                                            {
                                                                              "param_name": "v_w"
                                                                            },
                                                                            {
                                                                              "param_name": "s_i"
                                                                            },
                                                                            {
                                                                              "param_name": "s_v"
                                                                            },
                                                                            {
                                                                              "param_name": "s_u"
                                                                            },
                                                                            {
                                                                              "param_name": "summ"
                                                                            }
                                                                          ]
                                                                        }
                                                                      }
                                                                    ]
                                                                  }
                                                                }
                                                              ]
                                                            }
                                                          }
                                                        ]
                                                      }
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ],
                          "hint": "Где узнать"
                        }
                      }
                    ]
                  }
                },
                {
                  "text": "Нет",
                  "type": "button",
                  "next_question_id": {
                    "type": "input",
                    "text": "Общую площадь всех жилых помещений в доме!",
                    "answers": [
                      {
                        "text": "",
                        "type": "input",
                        "param_name": "s_v"
                      },
                      {
                        "type": "button",
                        "text": "Далее",
                        "next_question_id": {
                          "type": "input",
                          "text": "Общую площадь всех нежилых помещений в доме!",
                          "answers": [
                            {
                              "text": "",
                              "type": "input",
                              "param_name": "s_u"
                            },
                            {
                              "type": "button",
                              "text": "Далее",
                              "next_question_id": {
                                "type": "input",
                                "text": "Общую площадь помещений, входящих в состав общего имущества!",
                                "answers": [
                                  {
                                    "text": "",
                                    "type": "input",
                                    "param_name": "s_oi"
                                  },
                                  {
                                    "type": "button",
                                    "text": "Далее",
                                    "next_question_id": {
                                      "type": "input",
                                      "text": "Площадь твоей комнаты!",
                                      "answers": [
                                        {
                                          "text": "Сумма",
                                          "type": "input",
                                          "param_name": "s_i"
                                        },
                                        {
                                          "type": "button",
                                          "text": "Далее",
                                          "next_question_id": {
                                            "type": "input",
                                            "text": "Какая сумма у тебя в квитанции?",
                                            "answers": [
                                              {
                                                "text": "Сумма",
                                                "type": "input",
                                                "param_name": "summ"
                                              },
                                              {
                                                "type": "button",
                                                "text": "Далее",
                                                "next_question_id": {
                                                  "type": "input",
                                                  "text": "И введи норматив!",
                                                  "answers": [
                                                    {
                                                      "text": "",
                                                      "type": "input",
                                                      "param_name": "norm"
                                                    },
                                                    {
                                                      "type": "button",
                                                      "text": "Далее",
                                                      "method": {
                                                        "url": "formula15",
                                                        "params": [
                                                          {
                                                            "param_name": "s_u"
                                                          },
                                                          {
                                                            "param_name": "s_v"
                                                          },
                                                          {
                                                            "param_name": "s_oi"
                                                          },
                                                          {
                                                            "param_name": "s_i"
                                                          },
                                                          {
                                                            "param_name": "norm"
                                                          },
                                                          {
                                                            "param_name": "summ"
                                                          }
                                                        ]
                                                      }
                                                    }
                                                  ]
                                                }
                                              }
                                            ]
                                          }
                                        }
                                      ]
                                    }
                                  }
                                ]
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  ]
}