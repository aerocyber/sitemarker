enum SitemarkerTheme {
  lightTheme('Light', 'lightTheme'),
  darkTheme('Dark', 'darkTheme'),
  systemTheme('System', 'systemTheme');

  const SitemarkerTheme(this.themeName, this.themeValue);
  final String themeName;
  final String themeValue;
}
