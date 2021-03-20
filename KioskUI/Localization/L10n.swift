// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {

  public enum Coodly {
    public enum Feedback {
      public enum Controller {
        /// Conversations
        public static let title = L10n.tr("Localizable", "coodly.feedback.controller.title")
      }
      public enum Header {
        /// Please read this before posting
        public static let message = L10n.tr("Localizable", "coodly.feedback.header.message")
      }
      public enum Message {
        public enum Compose {
          public enum Controller {
            /// Write message
            public static let title = L10n.tr("Localizable", "coodly.feedback.message.compose.controller.title")
            public enum Send {
              /// Send
              public static let button = L10n.tr("Localizable", "coodly.feedback.message.compose.controller.send.button")
            }
          }
        }
      }
      public enum Response {
        /// Hello\n\nI'm Jaanus Siim, independent developer based in Estonia.\n\nEvery suggestion and feedback is welcome. I promise to read them all. But I may not be able to respond to all messages.\n\nThanks for undertanding.
        public static let notice = L10n.tr("Localizable", "coodly.feedback.response.notice")
      }
      public enum Sign {
        public enum In {
          /// Please sign in to iCloud to send a message.
          public static let message = L10n.tr("Localizable", "coodly.feedback.sign.in.message")
        }
      }
    }
  }

  public enum Kiosk {
    public enum Posts {
      public enum Controller {
        /// Gambrinus
        public static let title = L10n.tr("Localizable", "kiosk.posts.controller.title")
      }
    }
  }

  public enum Marked {
    public enum Controller {
      /// Notables
      public static let title = L10n.tr("Localizable", "marked.controller.title")
    }
  }

  public enum Menu {
    public enum Controller {
      public enum Option {
        /// Favorites
        public static let favorites = L10n.tr("Localizable", "menu.controller.option.favorites")
        /// Message to developer
        public static let feedback = L10n.tr("Localizable", "menu.controller.option.feedback")
        public enum All {
          /// All Posts
          public static let posts = L10n.tr("Localizable", "menu.controller.option.all.posts")
        }
      }
      public enum Sort {
        public enum By {
          /// RB beer name
          public static let beer = L10n.tr("Localizable", "menu.controller.sort.by.beer")
          /// brewer
          public static let brewer = L10n.tr("Localizable", "menu.controller.sort.by.brewer")
          /// date
          public static let date = L10n.tr("Localizable", "menu.controller.sort.by.date")
          /// post title
          public static let posts = L10n.tr("Localizable", "menu.controller.sort.by.posts")
          /// RB score
          public static let score = L10n.tr("Localizable", "menu.controller.sort.by.score")
          /// style
          public static let style = L10n.tr("Localizable", "menu.controller.sort.by.style")
          /// Untappd
          public static let untappd = L10n.tr("Localizable", "menu.controller.sort.by.untappd")
        }
        public enum Section {
          /// Sort by
          public static let title = L10n.tr("Localizable", "menu.controller.sort.section.title")
        }
      }
    }
  }

  public enum Post {
    public enum Extended {
      public enum Details {
        public enum Back {
          public enum Button {
            /// Back
            public static let title = L10n.tr("Localizable", "post.extended.details.back.button.title")
          }
        }
        public enum Brewer {
          /// Brewer
          public static let label = L10n.tr("Localizable", "post.extended.details.brewer.label")
        }
        public enum Posted {
          public enum On {
            /// Posted on
            public static let label = L10n.tr("Localizable", "post.extended.details.posted.on.label")
          }
        }
        public enum Style {
          /// Style
          public static let label = L10n.tr("Localizable", "post.extended.details.style.label")
        }
      }
    }
  }

  public enum Posts {
    public enum Controller {
      /// All Posts
      public static let title = L10n.tr("Localizable", "posts.controller.title")
      public enum Edit {
        /// Edit
        public static let button = L10n.tr("Localizable", "posts.controller.edit.button")
        public enum Done {
          /// Done
          public static let button = L10n.tr("Localizable", "posts.controller.edit.done.button")
        }
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
